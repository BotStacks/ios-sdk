import SwiftUI

public struct EmptyScreenConfig {
  let image: Image?
  let caption: String?

  public init(image: Image?, caption: String?) {
    self.image = image
    self.caption = caption
  }
}

public struct Assets {

  public let group: Image
  public let emptyThreads: EmptyScreenConfig
  public let emptyChat: EmptyScreenConfig
  public let emptyChannels: EmptyScreenConfig
  public let emptyAllChannels: EmptyScreenConfig

  func list(_ list: Chats.List) -> EmptyScreenConfig {
    switch list {
    case .groups:
      return emptyChannels
    case .threads:
      return emptyThreads
    case .users:
      return emptyChat
    }
  }

  public init(
    group: Image? = nil,
    emptyChannels: EmptyScreenConfig? = nil,
    emptyChat: EmptyScreenConfig? = nil,
    emptyThreads: EmptyScreenConfig? = nil,
    emptyAllChannels: EmptyScreenConfig? = nil
  ) {
    self.group = group ?? Image("users-three-fill")
    self.emptyChannels =
      emptyChannels
      ?? EmptyScreenConfig(
        image: AssetImage("empty-channels"), caption: "No channels yet. Go join one")
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
