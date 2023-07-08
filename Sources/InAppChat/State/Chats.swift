import Foundation

public class Chats: ObservableObject {

  @Published var user: User? = nil

  @Published var memberships: [Member] = []
  
  var dms: [Chat] {
    return self.memberships.filter { $0.chat.kind == Gql.ChatType.directMessage && $0.isMember }.map(\.chat)
  }
  
  var groups: [Chat] {
    return self.memberships.filter { $0.chat.kind == Gql.ChatType.group && $0.isMember }.map(\.chat)
  }
  
  let messages = ThreadsPager()
  let favorites = Favorites()
  let settings = Settings()
  let network = ChannelsPager()
  let contacts = ContactsPager()

  var pushToken: String?
  var fcmToken: String?

  @Published var lastUsedReactions =
    UserDefaults.standard.stringArray(forKey: "iac-last-used-reactions") ?? EmojiBar.defaults

  func onReaction(_ emoji: String) {
    lastUsedReactions.insert(emoji, at: 0)
    lastUsedReactions = lastUsedReactions.unique()
    lastUsedReactions = Array(lastUsedReactions[0..<5])
    UserDefaults.standard.set(lastUsedReactions, forKey: "iac-last-used-reactions")
  }

  @Published var loading = false

  public static var current = Chats()

  public func load() {
    if loading { return }
    loading = true
    Task.detached {
      do {
        try await self.loadAsync()
      } catch let err {
        Monitoring.error(err)
      }
      self.loading = false
    }
  }

  public func loadAsync() async throws {
    if api.authToken != nil {
      let user = try await api.start()
      print("loaded current user")
      await MainActor.run {
        self.user = user
      }
      print("got active threads")
      if let pushToken = pushToken {
        Task.detached {
          do {
            let _ = try await api.registerPushToken(pushToken)
          } catch let err {
            Monitoring.error(err)
          }
        }
      } else if let fcmToken = fcmToken {
        Task.detached {
          do {
            try await api.registerFCMToken(fcmToken)
          } catch let err {
            Monitoring.error(err)
          }
        }
      }
      try await loadGroupInvites()
    } else {
      print("no current user skipping")
    }
  }

  var invites: [String: [String]] = [:]

  public func loadGroupInvites() async throws {
    do {
      let invites = try await api.getInvites()
      await MainActor.run {
        invites.forEach {
          let chat = Chat.get(.init(_dataDict: $0.chat.__data))
          let user = User.get(.init(_dataDict: $0.user.__data))
          var i = self.invites[chat.id] ?? []
          i.append(user.id)
          self.invites[chat.id] = i
        }
      }
      
    } catch let err {
      Monitoring.error(err)
    }
  }
  
  func startSession(user: User) {
    self.user = user
    Task.detached {
      try await self.loadGroupInvites()
    }
  }

  public enum List: String {
    case groups = "Channels"
    case users = "Chat"
//    case threads = "Threads"
    static let all: [List] = [.groups, .users]
  }

  func count(_ list: List) -> Int {
    switch list {
    case .users:
      return dms.reduce(0) {
        return $0 + $1.unreadCount
      }
    case .groups:
      return groups.reduce(0) {
        return $0 + $1.unreadCount
      }
    }
  }
  
  var users: [User] {
    return dms.compactMap { $0.friend}
  }

  var phoneContacts: [User] = [] {
    didSet {
      contacts.items = Set(phoneContacts).union(Set(users)).sorted(by: {
        $0.displayNameFb > $1.displayNameFb
      })
    }
  }

  var cache = Caches()
}
