import SwiftUI

public struct EmptyScreenConfig {
  let image: UIImage?
  let caption: String?

  public init(image: UIImage?, caption: String?) {
    self.image = image
    self.caption = caption
  }
}

public struct Assets {

  public let logo: UIImage
  public let group: UIImage
  public let emptyThreads: EmptyScreenConfig
  public let emptyChat: EmptyScreenConfig
  public let emptyChannels: EmptyScreenConfig
  public let emptyAllChannels: EmptyScreenConfig

  func list(_ list: BotStacksChatStore.List) -> EmptyScreenConfig {
    switch list {
    case .groups:
      return emptyChannels
    case .users:
      return emptyChat
    }
  }

  public init(
    logo: UIImage? = nil,
    group: UIImage? = nil,
    emptyChannels: EmptyScreenConfig? = nil,
    emptyChat: EmptyScreenConfig? = nil,
    emptyThreads: EmptyScreenConfig? = nil,
    emptyAllChannels: EmptyScreenConfig? = nil
  ) {
    self.logo = logo ?? AssetImage("logo")
    self.group = group ?? AssetImage("users-three-fill")
    self.emptyChannels =
      emptyChannels
      ?? EmptyScreenConfig(
        image: AssetImage("empty-channels"), caption: "No channels yet bro. Go join one")
    self.emptyChat =
      emptyChat
      ?? EmptyScreenConfig(
        image: AssetImage("empty-chats"), caption: "Your friends are waiting for you")
    self.emptyThreads =
      emptyThreads
      ?? EmptyScreenConfig(
        image: AssetImage("empty-threads"), caption: "You haven't added any threads yet")
    self.emptyAllChannels =
      emptyAllChannels
      ?? EmptyScreenConfig(
        image: AssetImage("empty-all-channels"), caption: "No channels around here yet. Make one.")
  }

}
