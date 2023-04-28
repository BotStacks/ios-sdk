import Foundation
import SwiftDate
import SwiftyJSON

public final class User: ObservableObject, Identifiable {

  public var usernameFb: String {
    return !username.isEmpty ? username : displayName ?? email
  }

  public var displayNameFb: String {
    return (displayName ?? (!username.isEmpty ? username : email))
  }

  public let id: String
  @Published public var email: String
  @Published public var username: String
  @Published public var displayName: String?
  @Published public var avatar: String?
  @Published public var lastSeen: Date?
  @Published public var status: AvailabilityStatus = .offline
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
    email: String,
    username: String,
    displayName: String? = nil,
    avatar: String? = nil,
    lastSeen: Date? = nil,
    status: AvailabilityStatus = .offline,
    blocked: Bool = false
  ) {
    self.id = id
    self.email = email
    self.username = username
    self.displayName = displayName
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

  init(_ user: APIUser) {
    self.id = user.eRTCUserId
    self.email = user.appUserId
    self.username = user.name ?? ""
    self.lastSeen = user.loginTimeStamp.map { Date(milliseconds: $0) }
    self.blocked = Chats.current.settings.blocked.contains(user.eRTCUserId)
    self.update(user)
    Chats.current.cache.user[id] = self
    fetch()
  }

  func update(_ user: APIUser) {
    if email.isEmpty {
      self.email = user.appUserId
    }
    if let username = user.name {
      self.username = username
    }
    if let avatar = user.profilePic ?? user.profilePicThumb {
      self.avatar = avatar
    }
    if let lastSeen = user.loginTimeStamp {
      self.lastSeen = Date(milliseconds: lastSeen)
    }
    if let statusMessage = user.profileStatus {
      self.statusMessage = statusMessage
    }
    if let status = user.availabilityStatus {
      self.status = status
    }
  }

  func fetch() {
    let id = self.id
    Task.detached {
      do {
        let _ = try await api.get(user: id)
      } catch let err {
        Monitoring.error(err)
      }
    }
  }

  static func get(_ participant: Participant) -> User {
    if let user = get(participant.eRTCUserId) {
      return user
    }
    let user = User(id: participant.eRTCUserId, email: participant.appUserId, username: "")
    return user
  }

  static func get(_ user: APIUser) -> User {
    if let u = get(user.eRTCUserId) {
      u.update(user)
      return u
    }
    return User(user)
  }

  static func get(_ id: String) -> User? {
    return Chats.current.cache.user[id]
  }

  static func fetched(_ id: String) -> User {
    if let user = get(id) {
      return user
    }
    let user = User(id: id, email: "", username: "")
    return user
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
