import Combine
import Foundation
import SwiftyJSON

let assets =
  Bundle.main.url(forResource: "InAppChat", withExtension: "bundle").flatMap({ Bundle(url: $0) })
  ?? Bundle.main

public class InAppChat: ObservableObject {

  let apiKey: String
  let namespace: String

  private var didStartLoading = false

  @Published public var loaded: Bool = false
  @Published public var isUserLoggedIn: Bool = false
  @Published public var appMeta: [String: Any] = [:]
  public var config: JSON? = nil
  var user: User? {
    return Chats.current.user
  }

  public init(namespace: String, apiKey: String) {
    self.namespace = namespace
    self.apiKey = apiKey
  }

  public func load() async throws -> JSON {
    guard !didStartLoading else { return [:] }
    didStartLoading = true
    let tenant = try await api.fetchTenant()
    try await Chats.current.loadAsync()
    loaded = true
    let cfg = tenant["config"]
    self.config = cfg
    let chatServer = cfg["serverDetails"]["chatServer"]
    api.server = chatServer["url"].stringValue
    InAppChatAPI.customHeaders["X-API-Key"] = chatServer["apiKey"].stringValue
    InAppChatAPI.customHeaders["X-Device-Id"] = api.deviceId
    let mqttServer = cfg["serverDetails"]["mqttServer"]
    let mqttUrl = URL(string: mqttServer["url"].stringValue)!
    Socket.shared.host = mqttUrl.host!
    if let port = mqttUrl.port {
      Socket.shared.port = UInt16(port)
    }
    Socket.shared.apiKey = mqttServer["apiKey"].string
    return cfg
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
  public func auth0Login(
    accessToken: String, userId: String, email: String, picture: String?,
    name: String?,
    nickname: String?
  ) async throws {
    if loggingIn { return }
    await MainActor.run {
      loggingIn = true
    }
    do {
      let _ = try await api.login(
        accessToken: accessToken, userId: userId, email: email,
        picture: picture, name: name, nickname: nickname)
    } catch let err {
      Monitoring.error(err)
    }
    await MainActor.run {
      loggingIn = false
    }
  }

  public func nftLogin(
    contract: String,
    address: String,
    tokenID: String,
    signature: String,
    profilePicture: String,
    username: String?
  ) async throws {
    if loggingIn { return }
    loggingIn = true
    let _ = try await api.nftLogin(
      contract: contract,
      address: address,
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
    Socket.shared.disconnect()
    Task.detached {
      do {
        try await api.logout()
      } catch let err {
        Monitoring.error(err)
      }
    }
  }

  public static private(set) var shared: InAppChat!
  static func registerPushToken(_ data: Data) {
    let token = data.map { String(format: "%02.2hhx", $0) }.joined()
    registerPushToken(token)
  }

  static func registerPushToken(_ token: String) {
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

  static func registerFCMToken(_ token: String) {
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
