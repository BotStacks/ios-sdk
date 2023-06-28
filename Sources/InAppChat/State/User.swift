import Foundation
import SwiftDate
import SwiftyJSON

public final class User: ObservableObject, Identifiable {


  public var displayNameFb: String {
    return displayName ?? username
  }

  public let id: String
  @Published public var username: String
  @Published public var displayName: String?
  @Published public var description: String?
  @Published public var avatar: String?
  @Published public var lastSeen: Date?
  @Published public var status: Gql.OnlineStatus = .offline
  @Published public var blocked: Bool = false
  @Published public var statusMessage: String?
  @Published var haveContact: Bool = false

  var path: String {
    return "/user/\(id)"
  }

  var chatPath: String {
    return "\(path)/chat"
  }

  public var haveChatWith: Bool {
    return Chats.current.users.items.contains(where: { $0.user?.id == self.id })
  }

  public init(
    id: String,
    username: String,
    displayName: String? = nil,
    description: String? = nil,
    avatar: String? = nil,
    lastSeen: Date? = nil,
    status: Gql.OnlineStatus = .offline,
    blocked: Bool = false
  ) {
    self.id = id
    self.email = email
    self.username = username
    self.displayName = displayName
    self.description = description
    self.avatar = avatar
    self.lastSeen = lastSeen
    self.status = status
    self.blocked = blocked
    Chats.current.cache.user[id] = self
    fetch()
  }

  public static var current: User? = nil
  public lazy var sharedMedia: UserSharedMedia = UserSharedMedia(self.id)

  var isCurrent: Bool {
    return id == Self.current?.id
  }

  var blocking = false

  init(_ user: Gql.FUser) {
    self.init(
      id: user.id,
      username: user.username,
      lastSeen: user.last_seen.toDate()!.date,
      description: user.description,
      avatar: user.image,
      blocked: Chat.current.settings.blocked.contains(user.id)
    )
    self.id = user.eRTCUserId
    self.username = user.username
    self.displayName = user.display_name
    self.lastSeen = user.last_seen.toDate()!.date
    self.image = user.image
    self.status = user.status
    self.blocked = Chats.current.settings.blocked.contains(user.eRTCUserId)
    self.update(user)
    Chats.current.cache.user[id] = self
    fetch()
  }

  static func get(_ user: Gql.FUser) -> User {
    if let u = get(user.eRTCUserId) {
      u.update(user)
      return u
    }
    return User(user)
  }

  static func get(_ id: String) -> User? {
    return Chats.current.cache.user[id]
  }
}

public func == (l: User, r: User) -> Bool {
  return l.id == r.id
}

extension User: Equatable {

}

extension User: Hashable {
  public var hashValue: Int { return self.id.hashValue }

  public func hash(into hasher: inout Hasher) {
    self.id.hash(into: &hasher)
  }
}
