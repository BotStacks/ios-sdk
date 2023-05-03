import Foundation

public class Chats: ObservableObject {

  var currentUserID: String? = nil  //UserDefaults.standard.string(forKey: "iac-current-uid")
  {
    didSet {
      UserDefaults.standard.setValue(currentUserID, forKey: "iac-current-uid")
    }
  }
  @Published var user: User? = nil

  let groups = GroupsPager()
  let users = UsersPager()
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
    if let id = currentUserID {
      let user = try await api.start(id)
      print("loaded current user")
      await MainActor.run {
        self.user = user
      }
      print("got active threads")
      if let pushToken = pushToken {
        Task.detached {
          do {
            try await api.registerPushToken(pushToken)
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
      invites.forEach {
        var i = self.invites[$0.groupId] ?? []
        i.append($0.by)
        self.invites[$0.groupId] = i
      }
    } catch let err {
      Monitoring.error(err)
    }
  }

  public enum List: String {
    case groups = "Channels"
    case users = "Chat"
    case threads = "Threads"
    static let all: [List] = [.groups, .users, .threads]
  }

  func count(_ list: List) -> Int {
    switch list {
    case .users:
      return users.items.reduce(0) {
        return $0 + $1.unreadCount
      }
    case .groups:
      return groups.items.reduce(0) {
        return $0 + $1.unreadCount
      }
    case .threads:
      return 0
    }
  }

  var phoneContacts: [User] = [] {
    didSet {
      contacts.items = Set(phoneContacts).union(Set(users.items.compactMap(\.user))).sorted(by: {
        $0.displayNameFb > $1.displayNameFb
      })
    }
  }

  var cache = Caches()
}
