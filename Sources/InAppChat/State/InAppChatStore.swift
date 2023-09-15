import Foundation

public class InAppChatStore: ObservableObject {

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

  public static var current = InAppChatStore()

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
  
  private func loadMe() async throws {
    let (user, memberships) = try await api.start()
  }
  
  public var nft: Gql.GetNFTConfigQuery.Data.App.Nft?

  public func loadAsync() async throws {
    async let nft = loadNft()
    async let session = loadSession()
    _ = await [try nft, try session]
  }
  
  private func loadNft() async throws -> Bool {
    self.nft = try await api.nftConfig()
    return true
  }
  
  private func loadSession() async throws -> Bool {
    if api.authToken != nil {
      try await loadMe()
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
      network.loadMoreIfEmpty()
      contacts.loadMoreIfEmpty()
      if let token = pushToken {
        Task.detached {
          do {
            let _ = try await api.registerPushToken(token)
          } catch let err {
            Monitoring.error(err)
          }
        }
      }
    } else {
      print("no current user skipping")
    }
    return true
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
  
  var hiddenMessages = Set(UserDefaults.standard.stringArray(forKey: "iac-hidden-messages") ?? []) {
    didSet {
      UserDefaults.standard.set(hiddenMessages.unique(), forKey: "iac-hidden-messages")
    }
  }
  var hiddenUsers = Set(UserDefaults.standard.stringArray(forKey: "iac-hidden-users") ?? []) {
    didSet {
      UserDefaults.standard.set(hiddenUsers.unique(), forKey: "iac-hidden-users")
    }
  }
  @Published var hiddenChats = UserDefaults.standard.stringArray(forKey: "iac-hidden-chats") ?? [] {
    didSet {
      UserDefaults.standard.set(hiddenChats, forKey: "iac-hidden-chats")
    }
  }
  
}
