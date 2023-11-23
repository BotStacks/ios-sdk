import Combine
import Foundation
import SwiftyJSON

public class Tenant {
  public let loginType = "email"
}

let assets =
Bundle.main.url(forResource: "BotStacksChat", withExtension: "bundle", subdirectory: "Frameworks/BotStacksChat.framework").flatMap({Bundle(url: $0)})!
  
public class BotStacksChat: ObservableObject {

  let apiKey: String
  
  public let tenant = Tenant()

  private var didStartLoading = false

  @Published public var loaded: Bool = false
  @Published public var isUserLoggedIn: Bool = false
  @Published public var appMeta: [String: Any] = [:]
  public var hideBackButton = false
  public var onLogout: (() -> Void)? = nil
  public var onDeleteAccount: (() -> Void)? = nil
  
  var user: User? {
    return BotStacksChatStore.current.user
  }

  public init(apiKey: String) {
    self.apiKey = apiKey
    Monitoring.start()
  }
  

  public func load() async throws {
    guard !didStartLoading else { return }
    didStartLoading = true
    do {
      try await BotStacksChatStore.current.loadAsync()
    } catch {
      api.loggedOut()
    }
    await MainActor.run {
      self.loaded = true
    }
  }

  public static func setup(apiKey: String, delayLoad: Bool = false) {
    if apiKey.isEmpty {
      fatalError("BotStacks must be initiated with a valid api key.")
    }
    BotStacksChat.shared = BotStacksChat(apiKey: apiKey)
    if !delayLoad {
      Task {
        do {
          try await BotStacksChat.shared.load()
        } catch let err {
          Monitoring.error(err)
        }
      }
    }
  }

  @Published var loggingIn = false
  public func login(
    accessToken: String?, userId: String, username: String, picture: String?,
    displayName: String?
  ) async throws -> Bool {
    if loggingIn { return false }
    await MainActor.run {
      loggingIn = true
    }
    do {
      let _ = try await api.login(accessToken: accessToken, userId: userId, username: username, picture: picture, display_name: displayName)
    } catch let err {
        print("Error logging in ", err)
      Monitoring.error(err)
    }
    await MainActor.run {
      loggingIn = false
    }
    return isUserLoggedIn
  }
  
  public func basicLogin(
    email: String, password: String
  ) async throws -> Bool {
    if loggingIn { return false }
    await MainActor.run {
      loggingIn = true
    }
    do {
      let _ = try await api.basicLogin(email: email, password: password)
    } catch let err {
      print("Error logging in ", err)
      Monitoring.error(err)
    }
    await MainActor.run {
      loggingIn = false
    }
    return isUserLoggedIn
  }
  
  public func register(
    email: String, password: String,
    username: String,
    avatar: String?
  ) async throws -> Bool {
    if loggingIn { return false }
    await MainActor.run {
      loggingIn = true
    }
    do {
      let _ = try await api.register(email: email, password: password, username: username, picture: avatar)
    } catch let err {
      print("Error logging in ", err)
      Monitoring.error(err)
    }
    await MainActor.run {
      loggingIn = false
    }
    return isUserLoggedIn
  }

  public func nftLogin(
    address: String,
    tokenID: String,
    signature: String,
    profilePicture: String,
    username: String
  ) async throws -> Bool {
    if loggingIn { return false }
    await MainActor.run {
      loggingIn = true
    }
    let _ = try await api.nftLogin(
      wallet: address,
      tokenID: tokenID,
      signature: signature,
      profilePicture: profilePicture,
      username: username
    )
    await MainActor.run {
      loggingIn = false
    }
    return isUserLoggedIn
  }

  public static func load() async throws {
    let _ = try await shared.load()
  }

  public static func logout() {
    BotStacksChatStore.current = BotStacksChatStore()
    User.current = nil
    Task.detached {
      do {
        try await api.logout()
      } catch let err {
        Monitoring.error(err)
      }
    }
  }

  public static private(set) var shared: BotStacksChat!
  public static func registerPushToken(_ data: Data) {
    let token = data.map { String(format: "%02.2hhx", $0) }.joined()
    registerPushToken(token)
  }

  public static func registerPushToken(_ token: String) {
    BotStacksChatStore.current.pushToken = token
    if shared?.isUserLoggedIn != true { return }
    Task {
      do {
        print("Call Register Push")
        let _ = try await api.registerPushToken(token)
      } catch let err {
        Monitoring.error(err)
      }
    }
  }

  public static func registerFCMToken(_ token: String) {
    BotStacksChatStore.current.fcmToken = token
    if shared?.isUserLoggedIn != true { return }
    Task {
      do {
        try await api.registerFCMToken(token)
      } catch let err {
        Monitoring.error(err)
      }
    }
  }
  
  public static func uploadProfilePicture(_ url: URL) async throws -> String {
    return try await api.uploadFile(file: .init(url: url))
  }
  
  public static func set(theme: Theme) {
    Theme.current = theme
  }
}

public struct BotStacksChatError: Error {
  let msg: String?
}
