import Alamofire
import CryptoKit
import Foundation
import SwiftyJSON

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

let provisioningServerProd = "https://prov.ripbullertc.com/v1/tenants/get-tenant-details/"
let provisioningServerDev = "https://prov-dev.inappchat.io/v1/tenants/get-tenant-details/"
let provisioningServerQA = "https://prov-dev.ripbullertc.com/v1/tenants/get-tenant-details/"

let env = "prod"

func provisioningServer() -> String {
  switch env {
  case "qa":
    return provisioningServerQA
  case "dev":
    return provisioningServerDev
  default:
    return provisioningServerProd
  }
}

class Api {

  let deviceId: String
  var cfg: JSON!
  var server: String = "https://chat.inappchat.io/" {
    didSet {
      InAppChatAPI.basePath = server + "v3"
    }
  }

  var authToken: String? = UserDefaults.standard.string(forKey: "iac-auth-token")
  {
    didSet {
      UserDefaults.standard.set(authToken, forKey: "iac-auth-token")
      if let token = authToken {
        InAppChatAPI.customHeaders["Authorization"] = "Bearer \(token)"
      } else {
        InAppChatAPI.customHeaders["Authorization"] = nil
      }
    }
  }

  var refreshToken: String? = UserDefaults.standard.string(forKey: "iac-refresh-token")
  {
    didSet {
      UserDefaults.standard.set(refreshToken, forKey: "iac-refresh-token")
    }
  }

  var tokenExpiresAt: Date? = UserDefaults.standard.date(forKey: "iac-expires-in")
  {
    didSet {
      UserDefaults.standard.set(tokenExpiresAt, forKey: "iac-expires-in")
    }
  }

  init() {
    if let deviceId = UserDefaults.standard.string(forKey: "iac-device-id") {
      self.deviceId = deviceId
    } else {
      self.deviceId = UUID().uuidString
      UserDefaults.standard.set(deviceId, forKey: "iac-device-id")
    }
    InAppChatAPI.basePath = server + "v3"
    setHeaders()
  }

  func setHeaders() {
    InAppChatAPI.customHeaders = [
      "X-Device-ID": deviceId
    ]
    if let apiKey = InAppChat.shared?.apiKey {
      InAppChatAPI.customHeaders["X-API-Key"] = apiKey
    }
    if let token = authToken {
      InAppChatAPI.customHeaders["Authorization"] = "Bearer \(token)"
    }
  }

  func headers() -> HTTPHeaders {
    let ts = Date().timeIntervalSince1970
    let signature = "\(InAppChat.shared.apiKey)~\(Bundle.main.bundleIdentifier!)~\(ts)".sha256
    return [
      "X-API-Key": InAppChat.shared.apiKey,
      "X-Request-Signature": signature,
      "X-nonce": String(ts),
      "DeviceId": deviceId,
      "X-Device-ID": deviceId,
    ]
  }

  func fetchTenant() async throws -> JSON {
    let req = AF.request(
      provisioningServer() + InAppChat.shared.namespace, method: .get, headers: headers())
    print(req.cURLDescription())
    let cfg = JSON(try await req.serializingData().value)["result"]
    self.cfg = cfg
    return cfg
  }

  func fetchMessages(_ thread: Thread, pageSize: Int, currentMessageId: String? = nil) async throws
    -> [Message]
  {
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

  func updateMessageStatus(_ message: Message, status: MessageStatus) async throws {
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

  func update(group: Group, image: URL) async throws -> Group {
    let g = try await GroupAPI.updateGroup(
      gid: group.id, updateGroupInput: UpdateGroupInput(profilePic: image))
    return Group.get(g)
  }

  func update(group: Group, name: String?, description: String?, image: URL?, _private: Bool?)
    async throws -> Group
  {
    let input = UpdateGroupInput(
      name: name, groupType: _private != nil ? _private == true ? ._private : ._public : nil,
      description: description, profilePic: image)
    let g = try await GroupAPI.updateGroup(gid: group.id, updateGroupInput: input)
    return Group.get(g)
  }

  func createGroup(name: String, description: String?, image: URL?, private _private: Bool)
    async throws
    -> Group
  {
    let g = try await GroupAPI.createGroup(
      name: name, participants: [User.current!.id], groupType: _private ? ._private : ._public,
      description: description, profilePic: image)
    return Group.get(g)
  }

  func delete(group: Group) async throws {
    _ = try await GroupAPI.deleteGroup(gid: group.id)
  }

  func add(participant: User, to group: Group) async throws {
    try await GroupAPI.addParticipant(gid: group.id, uid: participant.id)
  }

  func remove(participant: User, from group: Group) async throws {
    try await GroupAPI.removeParticipant(gid: group.id, uid: participant.id)
  }

  func join(group: Group) async throws {
    try await add(participant: User.current!, to: group)
  }

  func leave(group: Group) async throws {
    try await remove(participant: User.current!, from: group)
  }

  func getGroup(_ id: String) async throws -> Group {
    let g = try await GroupAPI.getGroup(gid: id)
    return Group.get(g)
  }

  func dismiss(group: Group, admin: User) async throws {
    try await manage(group: group, admin: admin, isPromote: false)
  }

  func promote(group: Group, admin: User) async throws {
    try await manage(group: group, admin: admin, isPromote: true)
  }

  func manage(group: Group, admin: User, isPromote: Bool) async throws {
    if isPromote {
      _ = try await GroupAPI.groupAddAdmin(uid: group.id, gid: admin.id)
    } else {
      _ = try await GroupAPI.groupDismissAdmin(uid: group.id, gid: admin.id)
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
    return try await GroupAPI.getInvites()
  }

  func dismissInvites(for group: Group) async throws {
    try await GroupAPI.dismissGroupInvite(gid: group.id)
  }

  func invite(users: [User], to group: Group) async throws {
    try await GroupAPI.inviteUser(gid: group.id, requestBody: users.map(\.id))
  }

  func accept(invite toGroup: Group) async throws -> Thread {
    let t = try await GroupAPI.acceptGroupInvite(gid: toGroup.id)
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
      try await Chats.current.onLogin(user: user)
  }

  func onToken(accessToken: String, refreshToken: String?, tokenExpiresAt: Date) {
    self.authToken = accessToken
    self.refreshToken = refreshToken
    self.tokenExpiresAt = tokenExpiresAt
  }

    func auth0Login(accessToken: String,
                    refreshToken: String?,
                    expiresIn: Date,
                    email: String,
                    picture: String,
                    name: String,
                    nickname: String) async throws -> User {
    onToken(
      accessToken: accessToken, refreshToken: refreshToken,
      tokenExpiresAt: expiresIn)
    let res = try await AuthAPI.auth0Login(
      auth0LoginInput: .init(
        accessToken: accessToken, email: email, picture: picture, name: name,
        nickname: nickname, deviceId: deviceId, deviceType: .ios))
    let user = User.get(res.user)
    try await onUser(user)
    return user
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

  func updateSetting(notifications: NotificationSettings.AllowFrom) async throws {
    _ = try await UserAPI.updateMe(
      updateUserInput: .init(notificationSettings: .init(allowFrom: notifications)))
  }

  func update(availability: AvailabilityStatus) async throws {
    _ = try await UserAPI.updateMe(updateUserInput: .init(availabilityStatus: availability))
  }

  func update(thread: String, notifications: NotificationSettings.AllowFrom) async throws {
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

  func getJoinedGroupThreads(skip: Int = 0, limit: Int = 20) async throws -> [Thread] {
    return try await ThreadAPI.getThreads(skip: skip, limit: limit, threadType: .group).map(
      Thread.get)

  }

  func getGroups(skip: Int = 0, limit: Int = 20) async throws -> [Group] {
    return try await GroupAPI.getGroups(limit: limit, skip: skip, joined: .no).map(Group.get)
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

  func getThread(forGroup id: String) async throws -> Thread {
    return try await Thread.get(ThreadAPI.getGroupThread(gid: id))
  }

  func getThread(forUser id: String) async throws -> Thread {
    let t = try await ThreadAPI.createThread(uid: id)
    return Thread.get(t)
  }

  func getReplies(for message: Message, skip: Int = 0, limit: Int = 20) async throws -> [Message] {
    return try await ChatAPI.getReplies(mid: message.id, skip: skip, limit: limit).map(Message.get)
  }

  func registerPushToken(_ token: String) async throws {
    try await UserAPI.updateMe(updateUserInput: .init(apnsToken: token))
  }

  func registerFCMToken(_ token: String) async throws {
    try await UserAPI.updateMe(updateUserInput: .init(fcmToken: token))
  }

  func start(_ id: String) async throws -> User {
    let user = try await User.get(UserAPI.getUser(uid: id))
    User.current = user
    return user
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
