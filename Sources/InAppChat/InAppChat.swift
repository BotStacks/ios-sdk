import Combine
import Foundation
import SwiftyJSON

let assets =
Bundle.allBundles.compactMap({$0.url(forResource: "InAppChat", withExtension: "bundle").flatMap({Bundle(url: $0)})}).first
?? Bundle(for: InAppChat.self).url(forResource: "InAppChat", withExtension: "bundle").flatMap({Bundle(url: $0)})
  ?? Bundle.main

public class InAppChat: ObservableObject {

  let apiKey: String
  let namespace: String

  private var didStartLoading = false

  @Published public var loaded: Bool = false
  @Published public var isUserLoggedIn: Bool = false
  @Published public var appMeta: [String: Any] = [:]
  
  var user: User? {
    return Chats.current.user
  }

  public init(namespace: String, apiKey: String) {
    self.namespace = namespace
    self.apiKey = apiKey
    Monitoring.start()
  }

  public func load() async throws {
    guard !didStartLoading else { return }
    didStartLoading = true
    try await Chats.current.loadAsync()
  }

  public static func setup(namespace: String, apiKey: String, delayLoad: Bool = false) {
    InAppChat.shared = InAppChat(namespace: namespace, apiKey: apiKey)
    if !delayLoad {
      Task {
        try await InAppChat.shared.load()
      }
    }
  }

  @Published var loggingIn = false
  public func login(
    accessToken: String?, userId: String, username: String, picture: String?,
    displayName: String?
  ) async throws {
    if loggingIn { return }
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
  }

  public func nftLogin(
    address: String,
    tokenID: String,
    signature: String,
    profilePicture: String,
    username: String
  ) async throws {
    if loggingIn { return }
    loggingIn = true
    let _ = try await api.nftLogin(
      wallet: address,
      tokenID: tokenID,
      signature: signature,
      profilePicture: profilePicture,
      username: username
    )
  }

  public static func load() async throws {
    let _ = try await shared.load()
  }

  public static func logout() {
    Chats.current.currentUserID = nil
    Chats.current = Chats()
    User.current = nil
    Task.detached {
      do {
        try await api.logout()
      } catch let err {
        Monitoring.error(err)
      }
    }
  }

  public static private(set) var shared: InAppChat!
  public static func registerPushToken(_ data: Data) {
    let token = data.map { String(format: "%02.2hhx", $0) }.joined()
    registerPushToken(token)
  }

  public static func registerPushToken(_ token: String) {
    Chats.current.pushToken = token
    if shared?.isUserLoggedIn != true { return }
    Task {
      do {
        try await api.registerPushToken(token)
      } catch let err {
        Monitoring.error(err)
      }
    }
  }

  public static func registerFCMToken(_ token: String) {
    Chats.current.fcmToken = token
    if shared?.isUserLoggedIn != true { return }
    Task {
      do {
        try await api.registerFCMToken(token)
      } catch let err {
        Monitoring.error(err)
      }
    }
  }
}

public struct InAppChatError: Error {
  let msg: String?
}
