//
//  Group.swift
//  InAppChatUI
//
//  Created by Zaid Daghestani on 1/26/23.
//

import Foundation
import SwiftyJSON

extension Participant {
  var user: User {
    return User.get(self)
  }
}

public final class Group: ObservableObject, Identifiable {

  public let id: String

  @Published public var name: String
  @Published public var description: String?

  @Published public var image: String?

  @Published public var participants: [Participant]

  public var admins: [User] {
    return participants.filter({ $0.role == .admin }).map(\.user)
  }

  public var onlineNotAdminUsers: [User] {
    return participants.filter { $0.role != .admin }.map { $0.user }.filter {
      $0.status != .offline
    }
  }

  public var offlineUsers: [User] {
    return participants.filter { $0.role != .admin }.map(\.user).filter { $0.status == .offline }
  }

  @Published public var _private: Bool

  var isMember: Bool {
    return participants.map(\.user).contains(User.current!)
  }

  @Published var invites: Set<User>

  var hasInvite: Bool {
    return !invites.isEmpty
  }

  var isAdmin: Bool {
    return participants.contains(where: { $0.eRTCUserId == User.current?.id })
  }

  var path: String {
    return "/group/\(id)"
  }

  var editPath: String {
    return "/group/\(id)/edit"
  }

  var invitePath: String {
    return "/group/\(id)/invite"
  }

  @Published var invited: [User] = []

  public init(
    id: String,
    name: String,
    description: String? = nil,
    image: String? = nil,
    participants: [Participant] = [],
    _private: Bool = false,
    invites: [User] = []
  ) {
    self.id = id
    self.name = name
    self.description = description
    self.image = image
    self.participants = participants
    self._private = _private
    self.invites = Set(invites)
    Chats.current.cache.groups[id] = self
  }

  public init(_ group: APIGroup) {
    self.id = group.groupId
    self.name = group.name
    self.description = group.description
    self.image = group.profilePic ?? group.profilePicThumb
    self.participants = group.participants ?? []
    self._private = group.groupType == ._private
    self.invites = Set((Chats.current.invites[id] ?? []).map({User.fetched($0)}))
    Chats.current.cache.groups[id] = self
  }

  func update(_ group: APIGroup) {
    self.image = group.profilePic ?? group.profilePicThumb
    self.description = group.description
    self.name = group.name
    self._private = group.groupType == ._private
    if let participants = group.participants {
      self.participants = participants
    }
  }

  @Published var updating = false
  @Published var joining = false
  @Published var inviting = false

  static func get(_ group: APIGroup) -> Group {
    if let g = Chats.current.cache.groups[group.groupId] {
      g.update(group)
      return g
    }
    return Group(group)
  }

  static func get(_ id: String) -> Group? {
    return Chats.current.cache.groups[id]
  }
}
