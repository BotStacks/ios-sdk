import Alamofire
import Apollo
import CryptoKit
import Foundation
import SwiftyJSON

let servers = (
  prod: (
    host: "chat.inappchat.io",
    ssl: true
  ),
  dev: (host: "chat.dev.inappchat.io", ssl: true),
  local: (
    host: "localhost:3000",
    ssl: false
  )
)

let env = "prod"

func chatServer() -> (host: String, ssl: Bool) {
  switch env {
  case "local":
    return servers.local
  case "dev":
    return servers.dev
  default:
    return servers.prod
  }
}

extension String {
  var sha256: String {
    return SHA256.hash(data: Data(utf8)).compactMap { String(format: "%02x", $0) }.joined()
  }
}

struct APIError: Error {
  let msg: String
  let critical: Bool

  static func e(_ err: String?) -> APIError {
    return APIError(msg: err ?? "Unknown error occurred", critical: true)
  }
}

class Api: InterceptorProvider, ApolloInterceptor {
  var id: String = UUID().uuidString
  
  var client: ApolloClient?

  let deviceId: String
  var cfg: JSON!
  var store: ApolloStore

  var authToken: String? = UserDefaults.standard.string(forKey: "iac-auth-token")
  {
    didSet {
      UserDefaults.standard.set(authToken, forKey: "iac-auth-token")
      self.client = makeClient()
    }
  }

  var websocketUrl: String {
    let server = chatServer()
    let ext = server.ssl ? "wss" : "ws"
    return "\(ext)://\(server)/graphql"
  }

  var apiUrl: String {
    let server = chatServer()
    let ext = server.ssl ? "https" : "http"
    return "\(ext)://\(server)/graphql"
  }

  var websocketTransport: WebSocketTransport? {
    guard let authToken = authToken else {
      return nil
    }
    let url = URL(string: websocketUrl)!
    let webSocketClient = WebSocket(url: url, protocol: .graphql_transport_ws)
    let authPayload = ["authToken": authToken, "apiKey": InAppChat.shared.apiKey]
    let config = WebSocketTransport.Configuration(
      clientName: "inappchat-ios",
      clientVersion: "1.0.0",
      reconnect: true,
      reconnectionInterval: 60,
      allowSendingDuplicates: true,
      connectOnInit: true,
      connectingPayload: authPayload
    )
    return WebSocketTransport(websocket: webSocketClient, config: config)
  }
  
  var subscriptions = Array<Cancellable>()

  func subscribe() {
    if let client = client, authToken != nil {
      let sub = client.sub(subscription: Gql.CoreSubscription()) { [weak self] data in
        guard let self = self else {
          return
        }
        Chats.current.onCoreEvent(data.core)
      }
      subscriptions.append(sub)
      let subme = client.sub(subscription: Gql.MeSubscription()) { [weak self] data in
        guard let self = self else {
          return
        }
        Chats.current.onMeEvent(data)
      }
      subscriptions.append(subme)
    }
  };
  
  func unsubscribe() {
    for (let sub in subscriptions) {
      sub()
    }
    subscriptions.removeAll()
  }

  func makeClient() -> ApolloClient {
    unsubscribe()
    let store = ApolloStore()
    let apiTransport = RequestChainNetworkTransport(
      interceptorProvider: self, endpointURL: URL(string: self.apiUrl)!)
    var networkTransport: NetworkTransport = apiTransport
    if let socket = websocketTransport {
      networkTransport = SplitNetworkTransport(
        uploadingNetworkTransport: apiTransport, webSocketNetworkTransport: socket)
    }
    self.client = ApolloClient(networkTransport: networkTransport, store: store)
    subscribe()
    return self.client!
  }

  func interceptAsync<Operation>(
    chain: RequestChain, request: HTTPRequest<Operation>, response: HTTPResponse<Operation>?,
    completion: @escaping (Result<GraphQLResult<Operation.Data>, Error>) -> Void
  ) where Operation: GraphQLOperation {
    if let token = self.authToken {
      request.addHeader(name: "Authorization", value: "Bearer \(token)")
    }
    if let apiKey = InAppChat.shared.apiKey {
      request.addHeader(name: "X-API-Key", value: apiKey)
      request.addHeader(name: "X-Device-ID", value: deviceId)
    }
  }

  func interceptors<Operation>(for operation: Operation) -> [ApolloInterceptor]
  where Operation: GraphQLOperation {
    return [
      self,
      MaxRetryInterceptor(),
      NetworkFetchInterceptor(client: self.client),
      ResponseCodeInterceptor(),
      MultipartResponseParsingInterceptor(),
      JSONResponseParsingInterceptor(),
      AutomaticPersistedQueryInterceptor(),
    ]
  }

  
  init(store: ApolloStore) {
    self.store = store
    if let deviceId = UserDefaults.standard.string(forKey: "iac-device-id") {
      self.deviceId = deviceId
    } else {
      self.deviceId = UUID().uuidString
      UserDefaults.standard.set(deviceId, forKey: "iac-device-id")
    }
    self.client = makeClient()
  }
  
  func getGroups(skip: Int = 0, limit: Int = 20, search: String? = nil) async throws -> [Chat] {
    let res = try await client?.fetchAsync(query: Gql.ListGroupsQuery(count: skip, offset: limit, search: search))
    return res.groups.map(Chat.get)
  }
  
  func fetchMessages(_ chat: String, skip: Int = 0, limit: Int = 40, search: String? = nil) async throws
    -> [Message]
  {
    if let client = client {
      let res = try await client.fetchAsync(query: Gql.ListMessagesQuery(chat: chat, count: pageSize, offset: offset, search: search))
      return res.messages.map(Message.get)
    } else {
      return []
    }
  }
  
  func send(input: Gql.SendMessageInput) async throws -> {
    let send = try await client?.fetchAsync(query: Gql.SendMessageMutation(input: input))
    return Message.get(send.sendMessage)
  }

  func send(text: String, to chat: String, inReplyTo parent: String?)
    async throws
    -> Message
  {
    return try await send(input: Gql.SendMessageInput(
      text: text,
      chat: chat,
      parent: parent
    ))
  }

  func markRead(_ message: Message) async throws {
    try await updateMessageStatus(message, status: .seen)
  }

  func markReceived(_ message: Message) async throws {
    try await updateMessageStatus(message, status: .delivered)
  }

  func updateMessageStatus(_ message: Message, status: Message.Status) async throws {
    // TODO
  }

  func send(attachment: Gql.FMessage.Attachment, to chat: String, inReplyTo parent: String?)
    async throws -> Message
  {
    return try await self.send(input: Gql.SendMessageInput(chat: chat, attachments: [attachment]))
  }
  
  func updateGroup(input: Gql.UpdateGroupInput) async throws -> Boolean {
    let res = try await self.client?.fetchAsync(query: Gql.UpdateGroupMutation(
      input: input
    ))
    return res.updateGroup
  }

  func update(group: String, image: URL) async throws -> Bool {
    return try await self.updateGroup(input: Gql.UpdateGroupInput(input: id: group, image: image))
  }

  func update(group: String, name: String?, description: String?, image: URL?, _private: Bool?)
    async throws -> Bool
  {
    return try await self.updateGroup(input: Gql.UpdateGroupInput(id: group, name: name, description: description, image: image, _private: _private))
  }

  func createChat(name: String, description: String?, image: URL?, private _private: Bool)
    async throws
    -> Chat
  {
    let res = try await self.client?.fetchAsync(query: Gql.CreateGroupInput(name: name, description: description, image: image, _private: _private))
    return Chat.get(res.createGroup)
  }

  func delete(group: String) async throws {
    try await self.client?.fetchAsync(query: Gql.DeleteGroupMutation(id: group))
  }

  func join(group: String) async throws -> Member {
    let res = try await self.client?.fetchAsync(query: Gql.JoinChatMutation(id: group))
    if let fmember = res.join {
      return Member.fromGql(fmember)
    } else {
      throw APIError(msg: "Unable to join group. It may be private. Request an invitation.")
    }
  }

  func leave(group: String) async throws {
    try await self.client?.fetchAsync(query: Gql.LeaveChatMutation(id: group))
  }

  func dismiss(group: String, admin: String) async throws {
    try await manage(gdroup: group, admin: admin, isPromote: false)
  }

  func promote(group: String, admin: String) async throws {
    try await manage(group: group, admin: admin, isPromote: true)
  }

  func manage(group: String, admin: String, isPromote: Bool) async throws {
    try await self.client?.fetchAsync(query: Gql.ModMemberMutation(input: Gql.ModMemberInput(chat: group, user: admin, role: isPromote ? Gql.MemberRole.admin : Gql.MemberRole.member)))
  }

  func edit(message: String, text: String) async throws {
    let _ = try await self.client?.fetchAsync(query: Gql.UpdateMessageMutation(input: Gql.UpdateMessageInput(id: message, text: text)))
  }

  func delete(message: String) async throws {
    let _ = try await client?.fetchAsync(query: Gql.DeleteMessageMutation(id: message))
  }

  func favorite(message: Message, add: Bool) async throws {
    if (add) {
      let _ = try await client?.fetchAsync(query: Gql.FavoriteMutation(message: message.id))
    } else {
      let _ = try await client?.fetchAsync(query: Gql.UnfavoriteMutation(message: message.id))
    }
  }

  func favorites(skip: Int = 0, limit: Int = 20) async throws -> [Message] {
    let res = try await client?.fetchAsync(query: Gql.ListFavoritesQuery(offset: skip, count: limit))
    return res.favorites.map(Message.get)
  }

  func react(to message: String, reaction: String) async throws {
    let _ = try await client?.fetchAsync(query: Gql.ReactMutation(id: message, reaction: reaction))
  }

  func getInvites() async throws -> [Gql.GetInvitesQuery.Data.Invite] {
    let res = try await client?.fetchAsync(query: Gql.GetInvitesQuery())
    return res.invites
  }

  func dismissInvites(for chat: String) async throws {
    let _ = try await client?.fetchAsync(query: Gql.DismissInvitesMutation(chat:chat))
  }

  func invite(users: [String], to group: String) async throws -> [Member] {
    let res = try await self.client?.fetchAsync(query: Gql.InviteUsersMutation(chat: group, users: users))
    return res.inviteMany.map(Member.fromGql)
  }

  func accept(invite toChat: String) async throws -> Member {
    return self.join(group: toChat)
  }

  func getSharedMedia(user: String) async throws -> [Message] {
//    let msgs = try await DefaultAPI.getUserMessages(uid: user, skip: 0, limit: 10, msgType: .image)
//    return msgs.map(Message.get)
  }

  func onLogin(_ auth: Gql.LoginMutation.Data) async throws {
    onToken(
      accessToken: auth.token.accessToken, refreshToken: auth.token.refreshToken,
      tokenExpiresAt: Date().addingTimeInterval(auth.token.expiresIn))
    try await onUser(User.get(auth.user))
  }

  func onUser(_ user: User) async throws {
    await MainActor.run {
      Chats.current.user = user
      Chats.current.currentUserID = user.id
      User.current = user
    }
    do {
      try await Chats.current.loadAsync()
    } catch let err {
      Monitoring.error(err)
    }
  }

  func onToken(accessToken: String, refreshToken: String?, tokenExpiresAt: Date) {
    self.authToken = accessToken
    self.refreshToken = refreshToken
    self.tokenExpiresAt = tokenExpiresAt
  }

  func login(
    accessToken: String,
    userId: String,
    email: String,
    picture: String?,
    name: String?,
    nickname: String?
  ) async throws -> User {
    let res = try await self.client?.fetchAsync(
      query: Gql.LoginMutation(input:
        .init(
        userId: userId,
        accessToken: accessToken, email: email, picture: picture, name: name,
        nickname: nickname, deviceId: deviceId, deviceType: .ios)
      )
    )
    
    try await onLogin(res.login)
    return User.get(res.user)
  }

  public func nftLogin(
    contract: String,
    address: String,
    tokenID: String,
    signature: String,
    profilePicture: String,
    username: String?
  ) async throws -> User {
    let res = try await self.client?.fetchAsync(
      query: Gql.EthLoginMutation(
        input: Gql.EthLoginInput(
        address: address, contract: contract, signature: signature, tokenID: tokenID,
        username: username, profilePicture: profilePicture))
      )
    try await onLogin(res.ethLogin)
    return User.get(res.user)
  }

  func get(user: String) async throws -> User {
    let res = try await client?.fetchAsync(query: Gql.GetUserQuery(id: user))
    if let fuser = res.user {
      return User.get(fuser)
    } else {
      throw APIError(msg: "User not found", critical: false)
    }
  }

  func logout() async throws {
    _ = try await AuthAPI.logout()
    self.refreshToken = nil
    self.authToken = nil
    self.tokenExpiresAt = nil
  }

  func block(user: String) async throws {
    _ = try await client?.fetchAsync(query: Gql.BlockMutation(user: user))
  }
  func unblock(user: String) async throws {
    _ = try await client?.fetchAsync(query: Gql.UnblockMutation(user: user))
  }

  func updateSetting(notifications: NotificationSetting) async throws {
    _ = try await client?.fetchAsync(query: Gql.UpdateProfileInput(notification_settings: notifications))
  }

  func update(availability: OnlineStatus) async throws {
    _ = try await client?.fetchAsync(query: Gql.UpdateProfileInput(status: notifications))
  }

  func update(chat: String, notifications: NotificationSetting) async throws {
    _ = try await client?.fetchAsync(query: Gql.SetNotificationSettingMutation(chat: chat, setting: notifications))
  }

  func get(contacts: [String]) async throws {
    let _ = try await client?.fetchAsync(query: Gql.SyncContactsMutation(numbers: contacts))
  }

  func getReplyThreads(skip: Int = 0, limit: Int = 20) async throws -> [Message] {
    return try await ChatAPI.getReplyThreads(limit: limit, skip: skip).map(Message.get)
  }

  func get(chat: String) async throws -> Thread {
    return try await Thread.get(ThreadAPI.getThread(tid: thread))
  }

  func get(message: String) async throws -> Message {
    return try await Message.get(ChatAPI.getMessage(mid: message))
  }

  func getThread(forChat id: String) async throws -> Thread {
    return try await Thread.get(ThreadAPI.getChatThread(gid: id))
  }

  func getThread(forUser id: String) async throws -> Thread {
    let t = try await ThreadAPI.createThread(uid: id)
    return Thread.get(t)
  }

  func getReplies(for message: Message, skip: Int = 0, limit: Int = 20) async throws -> [Message] {
    return try await ChatAPI.getReplies(mid: message.id, skip: skip, limit: limit).map(Message.get)
  }

  func registerPushToken(_ token: String) async throws {
    let _ = User.get(try await UserAPI.updateMe(updateUserInput: .init(apnsToken: token)))
  }

  func registerFCMToken(_ token: String) async throws {
    let _ = try await UserAPI.updateMe(updateUserInput: .init(fcmToken: token))
  }

  func start(_ id: String) async throws -> User {
    let user = try await User.get(UserAPI.getUser(uid: id))
    User.current = user
    return user
  }

  func uploadFile(file: File) async throws -> String {
    var multipart = MultipartRequest()
    multipart.add(
      key: "file",
      fileName: file.name,
      fileMimeType: url.mimeType(),
      fileData: Data(contentsOf: file.url)
    )
    
    /// Create a regular HTTP URL request & use multipart
    let server = chatServer()
    let url = URL(string: "http\(server.ssl ? "s" : "")://\(server.host)/misc/upload")!
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.setValue(multipart.httpContentTypeHeadeValue, forHTTPHeaderField: "Content-Type")
    request.httpBody = multipart.httpBody
    
    /// Fire the request using URL sesson or anything else...
    let (data, response) = try await URLSession.shared.data(for: request)
    
    let json = try JSONSerialization.jsonObject(with: data, options: nil)
    if let url = json["url"] as String {
      return url
    } else {
      throw APIError(msg: "Unknown upload response \(String(data: data, encoding: .utf8))")
    }
  }
}

extension URL {
  public func mimeType() -> String {
    if let mimeType = UTType(filenameExtension: self.pathExtension)?.preferredMIMEType {
      return mimeType
    }
    else {
      return "application/octet-stream"
    }
  }
}

let api = Api(store: ApolloStore())

extension UserDefaults {
  func set(date: Date?, forKey key: String) {
    self.set(date, forKey: key)
  }

  func date(forKey key: String) -> Date? {
    return self.value(forKey: key) as? Date
  }
}

extension ApolloClient {
  public func fetchAsync<Query: GraphQLQuery>(query: Query,
                                         cachePolicy: CachePolicy = .default,
                                         contextIdentifier: UUID? = nil,
                                              queue: DispatchQueue = .main) async -> Query.Data {
    return withCheckedContinuation<Query.Data> { cont in
      self.networkTransport.send(operation: query,
                                 cachePolicy: cachePolicy,
                                 contextIdentifier: contextIdentifier,
                                 callbackQueue: queue) { result in
        switch (result) {
        case .success(let result):
          cont.with(result.data)
          break
        case .failure(let err):
          cont.resume(with: err)
        }
      }
    }
  }
}
