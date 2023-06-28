//
//  chat.swift
//  InAppChatUI
//
//  Created by Zaid Daghestani on 1/26/23.
//

import Foundation

public final class Chat: Pager<Message>, Identifiable {

  public let id: String
  public let kind: Gql.ChatType

  @Published public var name: String
  @Published public var description: String?
  @Published public var image: String?
  @Published public var members: [Member]
  @Published public var latestMessage: Message? = nil
  @Published public var unreadCount: Int = 0
  @Published public var typingUsers: [String] = []
  @Published public var sending: [Message] = []
  @Published public var failed: [Message] = []

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
    return members.contains(where: { $0.id == User.current?.id && $0.role === Gql.MemberRole.admin })
  }
  
  var friend: User? {
    return members.first(where: {!$0.user.isCurrent })?.user
  }
  
  var displayName: String {
    return self.name ?? self.friend?.usernameFb ?? ""
  }
  
  var displayImage: String? {
    return self.image ?? self.friend?.avatar
  }
  
  var isUnread: Bool {
    return unreadCount > 0
  }
  
  override public func load(skip: Int, limit: Int) async -> [Message] {
    do {
      let items = try await api.fetchMessages(
        self, pageSize: limit, currentMessageId: skip == 0 ? nil : self.items.last?.id)
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
    return "/chat/\(id)/edit"
  }

  var invitePath: String {
    return "/chat/\(id)/invite"
  }

  @Published var invited: [User] = []

  public init(
    id: String,
    name: String,
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
    self.latestMessage = latestMessage
    self._private = _private
    self.invites = Set(invites)
    Chats.current.cache.chats[id] = self
    if (kind == Gql.ChatType.directMessage), let friend = self.friend {
      Chats.current.cache.chatsByUID[friend.id] = self
    }
  }

  public convenience init(_ chat: Gql.FChat) {
    self.init(id: chat.id,
              name: chat.name,
              description: chat.description,
              image: chat.image,
              kind: chat.kind,
              members: Member.fromGql(chat.members),
              unreadCount: chat.unread_count,
              latestMessage: chat.last_message.map {Message.get($0)},
              _private: chat.private
    )
  }

  func update(_ chat: Gql.FChat) {
    self.image = chat.image
    self.description = chat.description
    self.name = chat.name
    self._private = chat.chatType == ._private
    self.members = Member.fromGql(chat.members)
    if let latestMessage = chat.last_message {
      self.latestMessage = Message.get(latestMessage)
    }
  }

  @Published var updating = false
  @Published var joining = false
  @Published var inviting = false

  static func get(_ chat: Gql.FChat) -> Chat {
    if let g = Chats.current.cache.chats[chat.chatId] {
      g.update(chat)
      return g
    }
    return chat(chat)
  }

  static func get(_ id: String) -> Chat? {
    return Chats.current.cache.chats[id]
  }
  
  static func get(uid: String) -> Thread? {
    return Chats.current.cache.threadsByUID[uid]
  }
  
  static func fetch(id: String) {
    if Chats.current.cache.chatFetches.contains(id) { return }
    Chats.current.cache.chatFetches.insert(id)
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
