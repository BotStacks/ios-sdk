import Apollo
import CryptoKit
import Foundation
import SwiftyJSON
import UIKit

let servers = (
  prod: (
    host: "chat.botstacks.ai",
    ssl: true
  ),
  dev: (host: "chat.dev.inappchat.io", ssl: true),
  local: (
    host: "localhost:3000",
    ssl: false
  )
)

let env = "local"

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

var debug = false

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
  
  var client: ApolloClient!

  let deviceId: String
  var cfg: JSON!
  var store: ApolloStore

  var authToken: String? = UserDefaults.standard.string(forKey: "iac-auth-token")
  {
    didSet {
      UserDefaults.standard.set(authToken, forKey: "iac-auth-token")
      socket?.updateConnectingPayload(connectingPayload)
      socket?.pauseWebSocketConnection()
      socket?.resumeWebSocketConnection()
    }
  }
  
  var connectingPayload: [String: String] {
    return authToken != nil ? ["authToken": authToken!, "apiKey": BotStacksChat.shared.apiKey] : ["apiKey": BotStacksChat.shared.apiKey]
  }
  var subscriptions = Array<Cancellable>()

  func subscribe() {
    print("Subscribe")
    if let client = client, authToken != nil, subscriptions.isEmpty {
      print("Create subs")
      let sub = client.sub(subscription: Gql.CoreSubscription()) { data in
        print("Got subscription event \(data.__data._data)")
        BotStacksChatStore.current.onCoreEvent(data.core)
      }
      subscriptions.append(sub)
      let subme = client.sub(subscription: Gql.MeSubscription()) { data in
        print("Got subscription event \(data.__data._data)")
        BotStacksChatStore.current.onMeEvent(data.me)
      }
      subscriptions.append(subme)
      socket?.resumeWebSocketConnection(autoReconnect: true)
    }
  };
  
  func unsubscribe() {
    for sub in subscriptions {
      sub.cancel()
    }
    subscriptions.removeAll()
    socket?.pauseWebSocketConnection()
  }

  func interceptAsync<Operation>(
    chain: RequestChain, request: HTTPRequest<Operation>, response: HTTPResponse<Operation>?,
    completion: @escaping (Result<GraphQLResult<Operation.Data>, Error>) -> Void
  ) where Operation: GraphQLOperation {
    if let token = self.authToken {
      request.addHeader(name: "Authorization", value: "Bearer \(token)")
    }
    request.addHeader(name: "X-API-Key", value: BotStacksChat.shared.apiKey)
    request.addHeader(name: "X-Device-ID", value: deviceId)
    request.addHeader(name: "Referer", value: Bundle.main.bundleIdentifier ?? "ios-sdk")
    chain.proceedAsync(request: request, response: response, interceptor: self, completion: completion)
  }

  func interceptors<Operation>(for operation: Operation) -> [ApolloInterceptor]
  where Operation: GraphQLOperation {
    return [
      self,
      MaxRetryInterceptor(),
      CacheReadInterceptor(store: self.store),
      RequestLoggingInterceptor(),
      NetworkFetchInterceptor(client: URLSessionClient()),
      ResponseCodeInterceptor(),
      MultipartResponseParsingInterceptor(),
      JSONResponseParsingInterceptor(),
      AutomaticPersistedQueryInterceptor(),
      CacheWriteInterceptor(store: self.store)
    ]
  }

  
//  private var cancelBag: Set<AnyCancellable> = []
  var socket: WebSocketTransport? = nil

  init(store: ApolloStore) {
    self.store = store
    if let deviceId = UserDefaults.standard.string(forKey: "iac-device-id") {
      self.deviceId = deviceId
    } else {
      self.deviceId = UUID().uuidString
      UserDefaults.standard.set(deviceId, forKey: "iac-device-id")
    }
    let websocketUrl: String = {
      let server = chatServer()
      let ext = server.ssl ? "wss" : "ws"
      return "\(ext)://\(server.host)/graphql"
    }()
    
    let apiUrl: String = {
      let server = chatServer()
      let ext = server.ssl ? "https" : "http"
      return "\(ext)://\(server.host)/graphql"
    }()
    let apiTransport = RequestChainNetworkTransport(
      interceptorProvider: self, endpointURL: URL(string: apiUrl)!)
    let url = URL(string: websocketUrl)!
    let webSocketClient = WebSocket(url: url, protocol: .graphql_transport_ws)
    let config = WebSocketTransport.Configuration(
      clientName: "botstackchat-ios",
      clientVersion: "1.0.0",
      reconnect: true,
      reconnectionInterval: 60,
      allowSendingDuplicates: true,
      connectOnInit: false,
      connectingPayload: connectingPayload
    )
    let websocketTransport = WebSocketTransport(websocket: webSocketClient, config: config)
    self.socket = websocketTransport
    self.client = ApolloClient(
      networkTransport:
        SplitNetworkTransport(
          uploadingNetworkTransport: apiTransport,
          webSocketNetworkTransport: websocketTransport
        ),
      store: store
    )
    NotificationCenter.default.addObserver(forName: UIApplication.didEnterBackgroundNotification, object: nil, queue: nil) { [unowned self] notification in
      self.unsubscribe()
    }
    NotificationCenter.default.addObserver(forName: UIApplication.willEnterForegroundNotification, object: nil, queue: nil, using: {
      [unowned self] notification in
      self.subscribe()
    })
  }
  
  
  
  func getGroups(skip: Int = 0, limit: Int = 20) async throws -> [Chat] {
    let res = try await client.fetchAsync(query: Gql.ListGroupsQuery(count: .some(limit), offset: .some(skip)))
    let chats = await MainActor.run {
      return res.groups.map {
        return Chat.get(Gql.FChat(_dataDict: $0.__data))
      }
    }
    return chats
  }
  
  func fetchMessages(_ chat: String, skip: Int = 0, limit: Int = 40, search: String? = nil) async throws
    -> [Message]
  {
    if let client = client {
      let res = try await client.fetchAsync(query: Gql.ListMessagesQuery(chat: chat, count: .some(limit), offset: .some(skip), search: search.map({.some($0)}) ?? .none))
      let messages = await MainActor.run {
        return res.messages.map {
          let _ = User.get(Gql.FUser(_dataDict: $0.user.__data))
          return Message.get(Gql.FMessage(_dataDict: $0.__data))
        }
      }
      return messages
    } else {
      return []
    }
  }
  
  func send(input: Gql.SendMessageInput) async throws -> Message {
    let send = try await client.performAsync(mutation: Gql.SendMessageMutation(input: input))
    return await MainActor.run {
      Message.get(.init(_dataDict: send.sendMessage.__data))
    }
  }

  func send(id: String, text: String, to chat: String, inReplyTo parent: String?)
    async throws
    -> Message
  {
    return try await send(input: Gql.SendMessageInput(
      chat: chat,
      id: .some(id),
      parent: parent.gqlSomeOrNone,
      text: .some(text)
    ))
  }
  
  func deleteChat(id: String) async throws {
    let _ = try await api.client.performAsync(mutation: Gql.DeleteGroupMutation(id: id))
    await MainActor.run {
      let store = BotStacksChatStore.current
      store.network.items.removeAll(where: {$0.id == id})
      store.memberships.removeAll(where: {$0.chat_id == id})
    }
  }

  func markRead(_ message: Message) async throws {
    try await updateMessageStatus(message, status: .seen)
  }
  
  func markChatRead(_ chat: String) async throws {
    let _ = try await self.client.performAsync(mutation: Gql.MarkChatReadMutation(id: chat))
  }

  func markReceived(_ message: Message) async throws {
    try await updateMessageStatus(message, status: .delivered)
  }

  func updateMessageStatus(_ message: Message, status: Message.Status) async throws {
    // TODO
  }

  func send(id: String, attachment: Gql.AttachmentInput, to chat: String, inReplyTo parent: String?)
    async throws -> Message
  {
    return try await self.send(input: Gql.SendMessageInput(attachments: [attachment], chat: chat, id: .some(id)))
  }
  
  func updateGroup(input: Gql.UpdateGroupInput) async throws -> Bool {
    let res = try await self.client.performAsync(mutation: Gql.UpdateGroupMutation(
      input: input
    ))
    return res.updateGroup
  }

  func update(group: String, image: URL) async throws -> Bool {
    let url = try await self.uploadFile(file: File(url: image))
    return try await self.updateGroup(input: Gql.UpdateGroupInput(id: group, image: .some(url)))
  }

  func update(group: String, name: String?, description: String?, image: URL?, _private: Bool?)
    async throws -> Bool
  {
    var _image: String? = nil
    if let image = image {
      _image = try await self.uploadFile(file: File(url: image))
    }
    return try await self.updateGroup(input: Gql.UpdateGroupInput(_private: _private.map({.some($0)}) ?? .none, description: description.map({.some($0)}) ?? .none, id: group, image: _image.map({.some($0)}) ?? .none, name: name.map({.some($0)}) ?? .none))
  }

  func createChat(name: String, description: String?, image: URL?, private _private: Bool?, invites: [String]?)
    async throws
    -> Chat
  {
    var _image: String? = nil
    if let image = image {
      _image = try await self.uploadFile(file: File(url: image))
    }
    let res = try await self.client.performAsync(mutation: Gql.CreateGroupMutation(input:  Gql.CreateGroupInput(_private: _private.gqlSomeOrNone, description: description.gqlSomeOrNone, image: _image.gqlSomeOrNone, invites: invites.map({GraphQLNullable.some($0)}) ?? .none, name: name)))
    if let g = res.createGroup {
      return await MainActor.run {
        let chat = Chat.get(Gql.FChat.init(_dataDict: g.__data))
        if let member = chat.membership {
          BotStacksChatStore.current.memberships.append(member)
        }
        BotStacksChatStore.current.network.items.append(chat)
        return chat
      }
    }
    throw APIError(msg: "No group returned", critical: true)
  }

  func delete(group: String) async throws -> Bool {
    let res = try await self.client.performAsync(mutation: Gql.DeleteGroupMutation(id: group))
    return res.deleteGroup
  }

  func join(group: String) async throws -> Member {
    let res = try await self.client.performAsync(mutation: Gql.JoinChatMutation(id: group))
    if let fmember = res.join {
      return Member.fromGql(.init(_dataDict: fmember.__data))
    } else {
      throw APIError(msg: "Unable to join group. It may be private. Request an invitation.", critical: false)
    }
  }

  func leave(group: String) async throws -> Bool {
    let res = try await self.client.performAsync(mutation: Gql.LeaveChatMutation(id: group))
    return res.leave
  }

  func dismiss(group: String, admin: String) async throws -> Bool {
    return try await manage(group: group, admin: admin, isPromote: false)
  }

  func promote(group: String, admin: String) async throws -> Bool {
    return try await manage(group: group, admin: admin, isPromote: true)
  }

  func manage(group: String, admin: String, isPromote: Bool) async throws -> Bool {
    let res = try await self.client.performAsync(mutation: Gql.ModMemberRoleMutation(input: Gql.ModMemberInput(chat: group, role: .some(.case(isPromote ? Gql.MemberRole.admin : Gql.MemberRole.member)), user: admin)))
    return res.modMember
  }

  func edit(message: String, text: String) async throws -> Bool {
    let edit = try await self.client.performAsync(mutation: Gql.UpdateMessageMutation(input: Gql.UpdateMessageInput(id: message, text: .some(text))))
    return edit.updateMessage
  }

  func delete(message: String) async throws -> Bool {
    return (try await client.performAsync(mutation: Gql.DeleteMessageMutation(id: message))).removeMessage
  }

  func favorite(message: Message, add: Bool) async throws -> Bool {
    if (add) {
      return (try await client.performAsync(mutation: Gql.FavoriteMutation(message: message.id))).favorite
    } else {
      return (try await client.performAsync(mutation: Gql.UnfavoriteMutation(message: message.id))).unfavorite
    }
  }

  func favorites(skip: Int = 0, limit: Int = 20) async throws -> [Message] {
    let res = try await client.fetchAsync(query: Gql.ListFavoritesQuery(count: .some(limit), offset: .some(skip)))
    return res.favorites.map{ Message.get(.init(_dataDict: $0.__data))}
  }

  func react(to message: String, reaction: String) async throws -> Bool {
    return (try await client.performAsync(mutation: Gql.ReactMutation(id: message, reaction: .some(reaction)))).react
  }

  func getInvites() async throws -> [Gql.GetInvitesQuery.Data.Invite] {
    let res = try await client.fetchAsync(query: Gql.GetInvitesQuery())
    return res.invites
  }

  func dismissInvites(for chat: String) async throws -> Bool {
    return try await client.performAsync(mutation: Gql.DismissInvitesMutation(chat:chat)).dismissInvites
  }

  func invite(users: [String], to group: String) async throws -> [Member] {
    let res = try await self.client.performAsync(mutation: Gql.InviteUsersMutation(chat: group, users: users))
    return res.inviteMany.map{Member.fromGql(.init(_dataDict: $0.__data))}
  }

  func accept(invite toChat: String) async throws -> Member {
    return try await self.join(group: toChat)
  }

  func getSharedMedia(user: String) async throws -> [Message] {
//    let msgs = try await DefaultAPI.getUserMessages(uid: user, skip: 0, limit: 10, msgType: .image)
//    return msgs.map(Message.get)
    return []
  }

  func onLogin(_ token: String, user: User) {
    onToken(token)
  }

  func onToken(_ token: String) {
    self.authToken = token
  }

  func login(
    accessToken: String?,
    userId: String,
    username: String,
    picture: String?,
    display_name: String?
  ) async throws -> User {
    
    let res = try await self.client.performAsync(
        mutation: Gql.LoginMutation(
          input: Gql.LoginInput(
            access_token: accessToken.gqlSomeOrNone, device: .none,
            display_name: display_name.gqlSomeOrNone, email: .none, image: picture.gqlSomeOrNone, user_id: userId,
            username: username
          )
        ),
        publishResultToStore: false
      )
    if let login = res.login {
      let user = User.get(.init(_dataDict: login.user.__data))
      onLogin(login.token, user: user)
      try await BotStacksChatStore.current.loadAsync()
      return user
    } else {
      throw APIError(msg: "Failed to login. No result.", critical: true)
    }
  }
  
  func register(
    email: String,
    password: String,
    username: String,
    picture: String?
  ) async throws -> User {
    
    let res = try await self.client.performAsync(
      mutation: Gql.ChatRegisterMutation(
        input: Gql.ChatRegisterInput(
          email: email,
          image: picture.map({.some($0)}) ?? .none,
          password: password,
          username: username
        )
      ),
      publishResultToStore: false
    )
    if let login = res.chatRegister {
      let user = User.get(.init(_dataDict: login.user.__data))
      onLogin(login.token, user: user)
      try await BotStacksChatStore.current.loadAsync()
      return user
    } else {
      throw APIError(msg: "Failed to login. No result.", critical: true)
    }
  }
  
  func basicLogin(email: String, password: String) async throws -> User {
    let res = try await self.client.performAsync(
      mutation: Gql.BasicLoginMutation(
        email: email,
        password: password
      ),
      publishResultToStore: false
    )
    if let login = res.basicLogin {
      let user = User.get(.init(_dataDict: login.user.__data))
      onLogin(login.token, user: user)
      try await BotStacksChatStore.current.loadAsync()
      return user
    } else {
      throw APIError(msg: "Failed to login. No result.", critical: true)
    }
  }

  public func nftLogin(
    wallet: String,
    tokenID: String,
    signature: String,
    profilePicture: String?,
    username: String
  ) async throws -> User {
    let res = try await self.client.performAsync(
      mutation: Gql.EthLoginMutation(
        input:
          Gql.EthLoginInput(
            device: .none, image: profilePicture.gqlSomeOrNone, signed_message: signature,
            token_id: tokenID, username: username, wallet: wallet))
      )
    if let login = res.ethLogin {
      let user = User.get(.init(_dataDict: login.user.__data))
      onLogin(login.token, user: user)
      try await BotStacksChatStore.current.loadAsync()
      return user
    } else {
      throw APIError(msg: "Eth login failed. No response data", critical: true)
    }
  }

  func get(user: String) async throws -> User {
    let res = try await client.fetchAsync(query: Gql.GetUserQuery(id: user))
    if let fuser = res.user {
      return User.get(.init(_dataDict: fuser.__data))
    } else {
      throw APIError(msg: "User not found", critical: false)
    }
  }

  func logout() async throws {
    _ = try await client.performAsync(mutation: Gql.LogoutMutation())
    self.loggedOut()
  }
  
  func loggedOut() {
    unsubscribe()
    self.authToken = nil
    
    DispatchQueue.main.async {
      BotStacksChat.shared.isUserLoggedIn = false
      BotStacksChat.shared.onLogout?()
      User.current = nil
      BotStacksChatStore.current = BotStacksChatStore()
    }
  }

  func block(user: String) async throws -> Bool {
    let res = try await client.performAsync(mutation: Gql.BlockMutation(user: user))
    return res.block
  }
  func unblock(user: String) async throws -> Bool {
    let res = try await client.performAsync(mutation: Gql.UnblockMutation(user: user))
    return res.unblock
  }

  func updateSetting(notifications: NotificationSetting) async throws -> Bool {
    let res = try await client.performAsync(mutation: Gql.UpdateProfileMutation(input: Gql.UpdateProfileInput(notification_setting: .some(.case(notifications)))))
    return res.updateProfile
  }

  func update(availability: OnlineStatus) async throws  -> Bool {
    let res = try await client.performAsync(mutation: Gql.UpdateProfileMutation(input: Gql.UpdateProfileInput(status: .some(.case(availability)))))
    return res.updateProfile
  }

  func update(chat: String, notifications: NotificationSetting) async throws -> Bool {
    let res = try await client.performAsync(mutation: Gql.SetNotificationSettingMutation(chat: chat, setting: .case(notifications)))
    return res.setNotificationSetting
  }

  func get(contacts: [String]) async throws -> Bool {
    let res = try await client.performAsync(mutation: Gql.SyncContactsMutation(numbers: contacts))
    return res.syncContacts
  }

  func getReplyThreads(skip: Int = 0, limit: Int = 20) async throws -> [Message] {
//    return try await ChatAPI.getReplyThreads(limit: limit, skip: skip).map(Message.get)
    return []
  }

  func get(chat: String) async throws -> Chat {
    let res = try await self.client.fetchAsync(query: Gql.GetChatQuery(id: id))
    if let fchat = res.chat {
      return Chat.get(.init(_dataDict: fchat.__data))
    } else {
      throw APIError(msg: "Chat not found", critical: false)
    }
  }

  func get(message: String) async throws -> Message {
    let res = try await self.client.fetchAsync(query: Gql.GetMessageQuery(id: message))
    if let fmessage = res.message {
      return Message.get(.init(_dataDict: fmessage.__data))
    } else {
      throw APIError(msg: "Message not found", critical: false)
    }
  }
  
  func dm(user: String) async throws -> Chat {
    let res = try await self.client.performAsync(mutation: Gql.DMMutation(user: user))
    if let dm = res.dm {
      return await MainActor.run {
        let chat = Chat.get(.init(_dataDict: dm.__data))
        if let member = chat.membership {
          BotStacksChatStore.current.memberships.append(member)
        }
        return chat
      }
      
    } else {
      throw APIError(msg: "Unable to dm user", critical: true)
    }
  }

  func getReplies(for message: String, skip: Int = 0, limit: Int = 20) async throws -> [Message] {
    let res = try await self.client.fetchAsync(query: Gql.ListRepliesQuery(message: message, skip: .some(skip), limit: .some(limit)))
    return res.replies.map {
      let _ = User.get(.init(_dataDict: $0.user.__data))
      return Message.get(.init(_dataDict: $0.__data))
    }
  }

  func registerPushToken(_ token: String) async throws -> Bool {
    let res = try await client.performAsync(mutation: Gql.RegisterPushMutation(token: token, kind: .case(Gql.DeviceType.ios), fcm: .some(false)))
    print("Did register push")
    return res.registerPush
  }

  func registerFCMToken(_ token: String) async throws {
    let _ = try await client.performAsync(mutation: Gql.RegisterPushMutation(token: token, kind: .case(Gql.DeviceType.ios), fcm: .some(true)))
  }
  
  func flag(input: Gql.CreateFlagInput) async throws {
    let _ = try await client.perform(mutation: Gql.FlagMutation(input: input))
  }

  func start() async throws -> (User, [Member]) {
    let res = try await client.fetchAsync(query: Gql.GetMeQuery())
    return await MainActor.run {
      let user = User.get(.init(_dataDict:res.me.__data))
      User.current = user
      let store = BotStacksChatStore.current
      store.user = user
      store.hiddenUsers.formUnion(res.me.blocks ?? [])
      let mraw = res.memberships
      let memberships: [Member] = mraw.map { it in
        let _ = Chat.get(Gql.FChat(_dataDict: it.chat.__data))
        return Member.fromGql(Gql.FMember(_dataDict: it.__data))
      }.filter {
        !($0.chat.isDM && store.hiddenUsers.contains($0.chat.friend?.id ?? ""))
      }
      store.memberships.removeAll()
      store.memberships.append(contentsOf: memberships)
      BotStacksChat.shared.isUserLoggedIn = true
      subscribe()
      return (user, memberships)
    }
  }
  
  func listUsers(skip: Int = 0, limit: Int = 20) async throws -> [User] {
    let res = try await client.fetchAsync(query: Gql.ListUsersQuery(count: .some(limit), offset: .some(skip)))
    return res.users.map { User.get(.init(_dataDict: $0.__data))}
  }
  
  func deleteAccount() async {
    do {
      let _ = try await client.performAsync(mutation: Gql.DeleteAccountMutation())
    } catch let err {
      Monitoring.error(err)
    }
    self.loggedOut()
    BotStacksChat.shared.onDeleteAccount?()
  }

  func uploadFile(file: File) async throws -> String {
    
    /// Create a regular HTTP URL request & use multipart
    let server = chatServer()
    let url = URL(string: "http\(server.ssl ? "s" : "")://\(server.host)/misc/upload/\(file.name.urlEncoded)")!
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.setValue(file.mimeType, forHTTPHeaderField: "Content-Type")
    if let token = authToken {
      request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
    }
    request.setValue(BotStacksChat.shared.apiKey, forHTTPHeaderField: "X-API-Key")
    request.httpBody = try Data(contentsOf: file.url)
    
    /// Fire the request using URL sesson or anything else...
    let (data, response) = try await URLSession.shared.data(for: request)
    print("Upload response \(String(data: data, encoding: .utf8))")
    
    if let json = try JSONSerialization.jsonObject(with: data, options: []) as? Dictionary<String, Any>,  let url = json["url"].flatMap({$0 as? String}) {
      return url
    } else {
      throw APIError(msg: "Unknown upload response \(response.debugDescription) \(String(data: data, encoding: .utf8) ?? "")", critical: true)
    }
  }
  
  func nftConfig() async throws -> Gql.GetNFTConfigQuery.Data.App.Nft? {
    let res = try await client.fetchAsync(query: Gql.GetNFTConfigQuery())
    return res.app.nft
  }
  
  func updateProfile(input: Gql.UpdateProfileInput) async throws -> Bool {
    let res = try await client.performAsync(mutation: Gql.UpdateProfileMutation(input: input))
    return res.updateProfile
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

extension Optional {
  var gqlSomeOrNone: GraphQLNullable<Wrapped> {
    return self.map({.some($0)}) ?? .none
  }
}
