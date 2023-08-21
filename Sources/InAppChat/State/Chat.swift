//
//  chat.swift
//  InAppChatUI
//
//  Created by Zaid Daghestani on 1/26/23.
//

import Foundation
import Combine

public final class Chat: Pager<Message>, Identifiable {

  public let id: String
  public let kind: Gql.ChatType

  @Published  var name: String?
  @Published  var description: String?
  @Published  var image: String?
  @Published  var members: [Member]
  @Published  var latestMessage: Message? = nil
  @Published  var unreadCount: Int = 0
  @Published  var typingUsers: [String] = []
  @Published  var sending: [Message] = []
  @Published  var failed: [Message] = []

   var admins: [User] {
    return members.filter({ $0.role == .admin }).map(\.user)
  }

   var onlineNotAdminUsers: [User] {
    return members.filter { $0.role != .admin }.map { $0.user }.filter {
      $0.status != .offline
    }
  }

   var offlineUsers: [User] {
    return members.filter { $0.role != .admin }.map(\.user).filter { $0.status == .offline }
  }
  
  var membership: Member? {
    return self.members.first(where: {$0.user_id == User.current?.id})
  }
  
  var sub = PassthroughSubject<Any, Error>()

  @Published  var _private: Bool

  var isMember: Bool {
    if let membership = self.membership {
      return membership.isMember
    }
    return false
  }

  @Published var invites: Set<User>

  var hasInvite: Bool {
    return !invites.isEmpty
  }

  var isAdmin: Bool {
    return self.membership?.role == .admin
  }
  
  var friend: User? {
    return members.first(where: {!$0.user.isCurrent })?.user
  }
  
  var displayName: String {
    return self.name ?? self.friend?.displayNameFb ?? ""
  }
  
  var displayImage: String? {
    return self.image ?? (self.isDM ? self.friend?.avatar : nil)
  }
  
  var isUnread: Bool {
    return unreadCount > 0
  }
  
  var isDM: Bool {
    return self.kind == Gql.ChatType.directMessage
  }
  
  var isGroup: Bool {
    return self.kind == Gql.ChatType.group
  }
  
  var activeMembers: [Member] {
    return members.filter({ $0.isMember})
  }
  
  override public func load(skip: Int, limit: Int) async -> [Message] {
    do {
      let items = try await api.fetchMessages(
        self.id, skip: skip, limit: limit)
      return items
    } catch let err {
      Monitoring.error(err)
      print("Error fetching message items \(err)")
    }
    return []
  }
  
  func addMessage(_ message: Message) {
    self.items.append(message)
  }


  var path: String {
    return "/chat/\(id)"
  }

  var editPath: String {
    return "/group/\(id)/edit"
  }

  var invitePath: String {
    return "/group/\(id)/invite"
  }

  @Published var invited: [User] = []
  
  var isInvited: Bool {
    return !self.invites.isEmpty || self.membership?.role == MemberRole.invited
  }
  

   init(
    id: String,
    name: String?,
    description: String? = nil,
    image: String? = nil,
    kind: Gql.ChatType,
    unreadCount: Int = 0,
    latestMessage: Message? = nil,
    members: [Member] = [],
    _private: Bool = false,
    invites: [User] = []
  ) {
    self.id = id
    self.name = name
    self.description = description
    self.image = image
    self.kind = kind
    self.members = members
    self.unreadCount = unreadCount
    print("Chat get with unread count \(unreadCount)")
    self.latestMessage = latestMessage
    self._private = _private
    self.invites = Set(invites)
    super.init()
    InAppChatStore.current.cache.chats[id] = self
    if (kind == Gql.ChatType.directMessage), let friend = self.friend {
      InAppChatStore.current.cache.chatsByUID[friend.id] = self
    }
  }

   convenience init(_ chat: Gql.FChat) {
    self.init(id: chat.id,
              name: chat.name,
              description: chat.description,
              image: chat.image,
              kind: chat.kind.value!,
              unreadCount: chat.unread_count,
              latestMessage: chat.last_message.map({Message.get(.init(_dataDict: $0.__data))}),
              members: Member.fromGql(chat.members.map({.init(_dataDict: $0.__data)})),
              _private: chat._private
    )
  }

  func update(_ chat: Gql.FChat) {
    self.image = chat.image
    self.description = chat.description
    self.name = chat.name
    self._private = chat._private
    self.members = Member.fromGql(chat.members.map({.init(_dataDict: $0.__data)}))
    if let latestMessage = chat.last_message {
      self.latestMessage = Message.get(.init(_dataDict: latestMessage.__data))
    }
  }

  @Published var updating = false
  @Published var joining = false
  @Published var inviting = false

  static func get(_ chat: Gql.FChat) -> Chat {
    if let g = InAppChatStore.current.cache.chats[chat.id] {
      g.update(chat)
      return g
    }
    return Chat(chat)
  }

  static func get(_ id: String) -> Chat? {
    return InAppChatStore.current.cache.chats[id]
  }
  
  static func get(uid: String) -> Chat? {
    return InAppChatStore.current.cache.chatsByUID[uid]
  }
  
  static func fetch(id: String) {
    if InAppChatStore.current.cache.chatFetches.contains(id) { return }
    InAppChatStore.current.cache.chatFetches.insert(id)
    Task.detached {
      do {
        let _ = try await api.get(chat: id)
      } catch let err {
        Monitoring.error(err)
        throw err
      }
    }
  }
}

extension Chat: Equatable {
  public static func ==(lhs: Chat, rhs: Chat) -> Bool {
    return lhs.id == rhs.id
  }
}
