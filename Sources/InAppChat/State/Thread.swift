//
//  Thread.swift
//  InAppChatUI
//
//  Created by Zaid Daghestani on 1/26/23.
//

import Foundation
import SwiftyJSON

public final class Thread: Pager<Message>, Identifiable {

  static public let id: String = "threadId"

  public let id: String
  public let user: User?
  public let group: Group?
  @Published public var unreadCount: Int = 0
  @Published public var typingUsers: [String] = []
  @Published public var sending: [Message] = []
  @Published public var failed: [Message] = []
  @Published public var notifications: NotificationSettings.AllowFrom = .all

  var name: String {
    return group?.name ?? user?.usernameFb ?? ""
  }

  var image: String? {
    return group?.image ?? user?.avatar
  }

  var isUnread: Bool {
    return unreadCount > 0
  }

  var path: String {
    if let user = user {
      return "/user/\(user.id)/chat"
    } else if let group = group {
      return "/group/\(group.id)"
    }
    return ""
  }

  @Published public var latest: Message?

  func cache() {
    Chats.current.cache.threads[id] = self
    if let user = user {
      Chats.current.cache.threadsByUID[user.id] = self
    } else if let group = group {
      Chats.current.cache.threadsByGroup[group.id] = self
    }
  }

  public init(
    id: String,
    user: User?,
    group: Group?,
    latest: Message?,
    items: [Message] = [],
    unreadCount: Int = 0
  ) {
    self.id = id
    self.user = user
    self.group = group
    self.latest = latest
    self.unreadCount = unreadCount
    super.init()
    self.items = items
    cache()
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

  var deleting = false

  init(_ t: APIThread) {
    self.id = t.threadId
    self.user = t.user.map(User.get)
    self.group = t.group.map(Group.get)
    self.latest = t.lastMessage.map(Message.get)
    super.init()
    cache()
  }

  func update(_ t: APIThread) {
    if let latest = t.lastMessage.map(Message.get) {
      self.latest = latest
    }
  }

  func set(notifications: NotificationSettings.AllowFrom, isSync: Bool) {
    self.notifications = notifications
    if isSync {
      return
    }
    Task.detached {
      do {
        try await api.update(thread: self.id, notifications: notifications)
      } catch let err {
        Monitoring.error(err)
      }
    }
  }

  static func get(_ thread: APIThread) -> Thread {
    if let t = get(thread.threadId) {
      t.update(thread)
      let _ = thread.user.map { User.get($0) }
      let _ = thread.group.map { Group.get($0) }
      return t
    }
    return Thread(thread)
  }

  static func get(_ id: String) -> Thread? {
    return Chats.current.cache.threads[id]
  }

  static func get(uid: String) -> Thread? {
    return Chats.current.cache.threadsByUID[uid]
  }

  static func get(group: String) -> Thread? {
    return Chats.current.cache.threadsByGroup[group]
  }

  static func fetch(id: String) {
    if Chats.current.cache.threadFetches.contains(id) { return }
    Chats.current.cache.threadFetches.insert(id)
    Task.detached {
      do {
        let _ = try await api.get(thread: id)
      } catch let err {
        Monitoring.error(err)
        throw err
      }
    }
  }
}
