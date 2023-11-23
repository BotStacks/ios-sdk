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
    return "/user/\(id)/chat"
  }

  public var haveChatWith: Bool {
    return BotStacksChatStore.current.users.contains(where: { $0.id == self.id })
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
    self.username = username
    self.displayName = displayName
    self.description = description
    self.avatar = avatar
    self.lastSeen = lastSeen
    self.status = status
    self.blocked = blocked
    BotStacksChatStore.current.cache.user[id] = self
  }

  public static var current: User? = nil
  public lazy var sharedMedia: UserSharedMedia = UserSharedMedia(self.id)

  var isCurrent: Bool {
    return id == Self.current?.id
  }

  var blocking = false
  
  func update(username: String, display_name: String?, last_seen: Date, image: String?, status: OnlineStatus) {
    self.username = username
    self.displayName = display_name
    self.lastSeen = last_seen
    self.avatar = image
    self.status = status
  }

  static func get(_ user: Gql.FUser) -> User {
    if let u = get(user.id) {
      u.update(username: user.username, display_name: user.display_name, last_seen: user.last_seen,
               image: user.image, status: user.status.value!)
      return u
    }
    return User(  id: user.id,
                  username: user.username,
                  displayName: user.display_name,
                  description: user.description,
                  avatar: user.image,
                  lastSeen: user.last_seen,
                  status: user.status.value!,
                  blocked: BotStacksChatStore.current.settings.blocked.contains(user.id)
    )
  }

  static func get(_ id: String) -> User? {
    return BotStacksChatStore.current.cache.user[id]
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
