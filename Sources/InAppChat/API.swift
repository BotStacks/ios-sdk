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

  static func e(_ err: String?) -> APIError {
    return APIError(msg: err ?? "Unknown error occurred")
  }
}

class Api: InterceptorProvider, ApolloInterceptor {
  var id: String = UUID().uuidString
  
  var client: ApolloClient?

  let deviceId: String
  var cfg: JSON!

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
    let authPayload = ["authToken": authToken]
    
    return WebSocketTransport(websocket: webSocketClient, connectingPayload: authPayload)
  }

  func subscribe() {
    if let client = client && authToken != nil {
      let sub = client.subscribe(subscription: CoreSubscription()) { [weak self] result in
        guard let self = self else {
          return
        }
        switch result {
        case .success(let graphQLResult):
          
        case .failure(let error):
          self.appAlert = .errors(errors: [error])
        }
      }
      subscriptions.append(sub)
    }
  };

  func makeClient() -> ApolloClient {
    let store = ApolloStore()
    let apiTransport = RequestChainNetworkTransport(
      interceptorProvider: self, endpointURL: URL(string: self.apiUrl)!)
    var networkTransport: NetworkTransport = apiTransport
    if let socket = websocketTransport {
      networkTransport = SplitNetworkTransport(
        uploadingNetworkTransport: apiTransport, webSocketNetworkTransport: socket)
    }
    return ApolloClient(networkTransport: networkTransport, store: store)
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

  init() {
    super.init(store: ApolloStore())
    if let deviceId = UserDefaults.standard.string(forKey: "iac-device-id") {
      self.deviceId = deviceId
    } else {
      self.deviceId = UUID().uuidString
      UserDefaults.standard.set(deviceId, forKey: "iac-device-id")
    }
    self.client = makeClient()
  }
  
  func fetchMessages(_ thread: Thread, pageSize: Int = 20, offset: Int = 0, search: String? = nil) async throws
    -> [Message]
  {
    if let client = client {
      client.fetch(query: ListMessagesQuery(chat: thread.id, count: pageSize, offset: offset, search: search))
    } else {
      return []
    }
    let msgs = try await ChatAPI.getMessages(
      tid: thread.id, direction: .past, pageSize: pageSize, inReplyTo: currentMessageId)
    return msgs.map(Message.get)
  }

  func send(text: String, to thread: Thread, inReplyTo parent: Message?)
    async throws
    -> Message
  {
    let msg = try await ChatAPI.sendMessage(
      senderTimeStampMs: Date().timeIntervalSince1970 * 1000, message: text,
      replyThreadFeatureData: parent.map({ Reply(baseMsgUniqueId: $0.id, replyMsgConfig: 1) }))
    return Message.get(msg.message!)
  }

  func markRead(_ message: Message) async throws {
    try await updateMessageStatus(message, status: .seen)
  }

  func markReceived(_ message: Message) async throws {
    try await updateMessageStatus(message, status: .delivered)
  }

  func updateMessageStatus(_ message: Message, status: Message.Status) async throws {
    try await ChatAPI.updateMessage(
      mid: message.id, updateMessageInput: .init(status: status)
    )
  }

  func send(attachment: Message.Attachment, to thread: Thread, inReplyTo parent: Message?)
    async throws -> Message
  {
    let res = try await ChatAPI.sendMessage(
      senderTimeStampMs: Date().timeIntervalSince1970 * 1000,
      threadId: thread.id, msgType: .init(rawValue: attachment.kind.rawValue)!,
      file: try attachment.url.asURL(),
      replyThreadFeatureData: parent.map({ Reply(baseMsgUniqueId: $0.id, replyMsgConfig: 1) }))
    return Message.get(res.message!)
  }

  func send(gif: String, to thread: Thread, inReplyTo parent: Message?) async throws -> Message {
    let res = try await ChatAPI.sendMessage(
      senderTimeStampMs: Date().timeIntervalSince1970 * 1000,
      threadId: thread.id,
      replyThreadFeatureData: parent.map({ Reply(baseMsgUniqueId: $0.id, replyMsgConfig: 1) }),
      gif: gif)
    return Message.get(res.message!)
  }

  func send(location: Location, to thread: Thread, inReplyTo parent: Message?)
    async throws -> Message
  {
    let res = try await ChatAPI.sendMessage(
      senderTimeStampMs: Date().timeIntervalSince1970 * 1000,
      threadId: thread.id,
      replyThreadFeatureData: parent.map({ Reply(baseMsgUniqueId: $0.id, replyMsgConfig: 1) }),
      location: location)
    return Message.get(res.message!)
  }

  func send(contact: Contact, to thread: Thread, inReplyTo parent: Message?) async throws
    -> Message
  {
    let res = try await ChatAPI.sendMessage(
      senderTimeStampMs: Date().timeIntervalSince1970 * 1000,
      threadId: thread.id,
      replyThreadFeatureData: parent.map({ Reply(baseMsgUniqueId: $0.id, replyMsgConfig: 1) }),
      contact: contact)
    return Message.get(res.message!)
  }

  func update(group: Chat, image: URL) async throws -> Chat {
    let g = try await ChatAPI.updateChat(
      gid: group.id, updateChatInput: UpdateChatInput(profilePic: image))
    return Chat.get(g)
  }

  func update(group: Chat, name: String?, description: String?, image: URL?, _private: Bool?)
    async throws -> Chat
  {
    let input = UpdateChatInput(
      name: name, groupType: _private != nil ? _private == true ? ._private : ._public : nil,
      description: description, profilePic: image)
    let g = try await ChatAPI.updateChat(gid: group.id, updateChatInput: input)
    return Chat.get(g)
  }

  func createChat(name: String, description: String?, image: URL?, private _private: Bool)
    async throws
    -> Chat
  {
    let g = try await ChatAPI.createChat(
      name: name, participants: [User.current!.id], groupType: _private ? ._private : ._public,
      description: description, profilePic: image)
    return Chat.get(g)
  }

  func delete(group: Chat) async throws {
    _ = try await ChatAPI.deleteChat(gid: group.id)
  }

  func add(participant: User, to group: Chat) async throws {
    try await ChatAPI.addParticipant(gid: group.id, uid: participant.id)
  }

  func remove(participant: User, from group: Chat) async throws {
    try await ChatAPI.removeParticipant(gid: group.id, uid: participant.id)
  }

  func join(group: Chat) async throws {
    try await add(participant: User.current!, to: group)
  }

  func leave(group: Chat) async throws {
    try await remove(participant: User.current!, from: group)
  }

  func getChat(_ id: String) async throws -> Chat {
    let g = try await ChatAPI.getChat(gid: id)
    return Chat.get(g)
  }

  func dismiss(group: Chat, admin: User) async throws {
    try await manage(group: group, admin: admin, isPromote: false)
  }

  func promote(group: Chat, admin: User) async throws {
    try await manage(group: group, admin: admin, isPromote: true)
  }

  func manage(group: Chat, admin: User, isPromote: Bool) async throws {
    if isPromote {
      _ = try await ChatAPI.groupAddAdmin(uid: group.id, gid: admin.id)
    } else {
      _ = try await ChatAPI.groupDismissAdmin(uid: group.id, gid: admin.id)
    }
  }

  func edit(message: Message, text: String) async throws {
    try await ChatAPI.updateMessage(mid: message.id, updateMessageInput: .init(message: text))
  }

  func delete(message: Message) async throws {
    try await ChatAPI.deleteMessage(mid: message.id)
  }

  func favorite(message: Message, add: Bool) async throws {
    try await ChatAPI.updateMessage(mid: message.id, updateMessageInput: .init(isStarred: add))
  }

  func favorites(skip: Int = 0, limit: Int = 20) async throws -> [Message] {
    let res = try await ChatAPI.getFavorites(skip: skip, limit: limit)
    return res.map(Message.get)
  }

  func react(to message: Message, reaction: String, set: Bool) async throws {
    if set {
      try await ChatAPI.react(mid: message.id, emoji: reaction)
    } else {
      try await ChatAPI.unreact(mid: message.id, emoji: reaction)
    }
  }

  func getInvites() async throws -> [Invite] {
    return try await ChatAPI.getInvites()
  }

  func dismissInvites(for group: Chat) async throws {
    try await ChatAPI.dismissChatInvite(gid: group.id)
  }

  func invite(users: [User], to group: Chat) async throws {
    try await ChatAPI.inviteUser(gid: group.id, requestBody: users.map(\.id))
  }

  func accept(invite toChat: Chat) async throws -> Thread {
    let t = try await ChatAPI.acceptChatInvite(gid: toChat.id)
    return Thread.get(t)
  }

  func getSharedMedia(user: String) async throws -> [Message] {
    let msgs = try await DefaultAPI.getUserMessages(uid: user, skip: 0, limit: 10, msgType: .image)
    return msgs.map(Message.get)
  }

  func onLogin(_ auth: Auth) async throws {
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
    let res = try await AuthAPI.login(
      loginInput: .init(
        userId: userId,
        accessToken: accessToken, email: email, picture: picture, name: name,
        nickname: nickname, deviceId: deviceId, deviceType: .ios))
    try await onLogin(res)
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
    let res = try await AuthAPI.nftLogin(
      nFTLoginInput: .init(
        address: address, contract: contract, signature: signature, tokenID: tokenID,
        username: username, profilePicture: profilePicture))
    try await onLogin(res)
    return User.get(res.user)
  }

  func get(user: String) async throws -> User {
    let user = try await UserAPI.getUser(uid: user)
    return User.get(user)
  }

  func logout() async throws {
    _ = try await AuthAPI.logout()
    self.refreshToken = nil
    self.authToken = nil
    self.tokenExpiresAt = nil
  }

  func block(user: User, isBlock: Bool) async throws {
    if isBlock {
      _ = try await UserAPI.blockUser(uid: user.id)
    } else {
      _ = try await UserAPI.unblockUser(uid: user.id)
    }
  }

  func updateSetting(notifications: Settings.Notifications) async throws {
    _ = try await UserAPI.updateMe(
      updateUserInput: .init(notificationSettings: .init(allowFrom: notifications)))
  }

  func update(availability: Gql.OnlineStatus) async throws {
    _ = try await UserAPI.updateMe(updateUserInput: .init(availabilityStatus: availability))
  }

  func update(thread: String, notifications: Settings.Notifications) async throws {
    _ = try await ThreadAPI.updateThread(
      tid: thread, updateThreadInput: .init(notificationSettings: .init(allowFrom: notifications)))
  }

  func get(contacts: [String]) async throws -> [User] {
    let users = try await UserAPI.syncContacts(syncContactsInput: .init(contacts: contacts))
    return users.map(User.get)
  }

  func getJoinedUserThreads(skip: Int = 0, limit: Int = 20) async throws -> [Thread] {
    return try await ThreadAPI.getThreads(skip: skip, limit: limit, threadType: .single).map(
      Thread.get)
  }

  func getJoinedChatThreads(skip: Int = 0, limit: Int = 20) async throws -> [Thread] {
    return try await ThreadAPI.getThreads(skip: skip, limit: limit, threadType: .group).map(
      Thread.get)

  }

  func getChats(skip: Int = 0, limit: Int = 20) async throws -> [Chat] {
    return try await ChatAPI.getChats(limit: limit, skip: skip, joined: .no).map(Chat.get)
  }

  func getReplyThreads(skip: Int = 0, limit: Int = 20) async throws -> [Message] {
    return try await ChatAPI.getReplyThreads(limit: limit, skip: skip).map(Message.get)
  }

  func get(thread: String) async throws -> Thread {
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

let api = Api()

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
                                         queue: DispatchQueue = .main,
                                         resultHandler: GraphQLResultHandler<Query.Data>? = nil) -> Cancellable {
    return withCheckedContinuation<Query.Data> { cont in
      self.networkTransport.send(operation: query,
                                 cachePolicy: cachePolicy,
                                 contextIdentifier: contextIdentifier,
                                 callbackQueue: queue) { result in
      
      }
    }
  }
}
