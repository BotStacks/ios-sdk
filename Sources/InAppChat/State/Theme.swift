//
//  Theme.swift
//  InAppChatUI
//
//  Created by Zaid Daghestani on 1/24/23.
//

import DynamicColor
import Foundation
import SwiftUI

let darkMode = true

public func base(size: CGFloat, weight: Font.Weight = .regular) -> Font {
  return .system(size: size, weight: weight)
}

public struct Fonts {
  public let title: Font
  public let title2: Font
  public let title2Regular: Font
  public let title3: Font
  public let headline: Font
  public let body: Font
  public let caption: Font
  public let username: Font
  public let timestamp: Font
  public let mini: Font

  public init(
    title: Font = .title,
    title2: Font = .title2,
    title2Regular: Font = base(size: 22),
    title3: Font = .title3,
    headline: Font = .headline,
    body: Font = .body,
    caption: Font = .caption,
    username: Font = base(size: 12.0, weight: .heavy),
    timestamp: Font = base(size: 12.0),
    mini: Font = base(size: 10.0)
  ) {
    self.title = title
    self.title2 = title2
    self.title2Regular = title2Regular
    self.title3 = title3
    self.headline = headline
    self.body = body
    self.caption = caption
    self.username = username
    self.timestamp = timestamp
    self.mini = mini
  }
}

public struct Colors {
  public let primary: Color
  public let button: Color
  public let destructive: Color
  public let text: Color
  public let caption: Color
  public let unread: Color
  public let `public`: Color
  public let `private`: Color
  public let background: Color
  public let softBackground: Color
  public let bubble: Color
  public let bubbleText: Color
  public let senderBubble: Color
  public let senderText: Color
  public let username: Color
  public let senderUsername: Color
  public let timestamp: Color
  public let border: Color

  public init(
    light: Bool,
    primary: Color? = nil,
    text: Color? = nil,
    bubble: Color? = nil,
    bubbleText: Color? = nil,
    senderBubble: Color = Color(hex: 0xE5ECFF),
    senderText: Color? = nil,
    senderUsername: Color? = nil,
    timestamp: Color? = nil,
    button: Color? = nil,
    destructive: Color? = nil,
    background: Color? = nil,
    softBackground: Color? = nil,
    caption: Color? = nil,
    unread: Color? = nil,
    public: Color? = nil,
    private: Color? = nil,
    username: Color? = nil,
    border: Color? = nil
  ) {
    self.senderBubble = senderBubble
    self.bubble =
      bubble ?? (light ? Color(hex: 0xF0F0F0) : Color(hex: 0x2B2B2B))
    self.senderText = senderText ?? (bubble == nil ? Color(hex: 0x202127) : Color(hex: 0xE3E3E3))
    self.senderUsername = senderUsername ?? (light ? .black : .white)
    self.text = text ?? (light ? Color(hex: 0x1C1C1C) : Color(hex: 0xE3E3E3))
    self.bubbleText = bubbleText ?? (light ? Color(hex: 0x1C1C1C) : Color(hex: 0xE3E3E3))
    self.username = username ?? (light ? Color(hex: 0x2D3237) : Color(hex: 0xE3E3E3))
    self.timestamp =
      timestamp ?? (light ? Color(hex: 0x71869C) : Color(hex: 0xE3E3_E34D))
    self.primary = primary ?? Color(hex: 0x0091ff)
    self.button = button ?? (light ? Color(hex: 0xF0F0F0) : Color(hex: 0x2B2B2B))
    self.background = background ?? (light ? Color(hex: 0xFFFFFF) : Color(hex: 0x171717))
    self.destructive = destructive ?? Color(hex: 0xC74848)
    self.softBackground =
      softBackground
      ?? (light ? Color(hex: 0xD4D4D4) : Color(hex: 0x2B2B2B))
    self.caption =
      caption
      ?? (light
        ? Color(hex: 0x2C2C2C_50, useOpacity: true) : Color(hex: 0xE3E3_E350, useOpacity: true))
    self.unread = unread ?? Color(hex: 0xC74848)
    self.public = `public` ?? Color(hex: 0x4B48C7)
    self.private = `private` ?? Color(hex: 0x488AC7)
    self.border = border ?? (light ? Color(hex: 0x1B1B1B) : Color(hex: 0xE3E3E3))
  }
}

public class Theme {

  public let fonts: Fonts
  public let light: Colors
  public let dark: Colors
  public let imagePreviewSize: CGSize
  public let videoPreviewSize: CGSize
  public let bubbleRadius: CGFloat
  public let showAvatar: Bool
  public let avatarSize: CGFloat
  public let bubblePadding: EdgeInsets
  public let messageAlign: HorizontalAlignment
  public let senderAlign: HorizontalAlignment
  public let assets: Assets

  public var current: ColorScheme = .light
  public var colors: Colors {
    return current == .light ? light : dark
  }
  public var inverted: Colors {
    return current == .light ? dark : light
  }

  func with(_ colorScheme: ColorScheme) -> Theme {
    self.current = colorScheme
    return self
  }

  public init(
    light: Colors? = nil,
    dark: Colors? = nil,
    fonts: Fonts? = nil,
    showAvatar: Bool = true,
    avatarSize: CGFloat = 17.5,
    imagePreviewSize: CGSize = CGSize(width: 178.0, height: 153.0),
    videoPreviewSize: CGSize = CGSize(width: 248.0, height: 153.0),
    messageAlign: HorizontalAlignment = .leading,
    senderAlign: HorizontalAlignment = .trailing,
    bubbleRadius: CGFloat = 7.5,
    bubblePadding: EdgeInsets = EdgeInsets(top: 6.0, leading: 6.0, bottom: 6.0, trailing: 6.0),
    assets: Assets = Assets()
  ) {
    self.light = light ?? Colors(light: true)
    self.dark = dark ?? Colors(light: false)
    self.fonts = fonts ?? Fonts()
    self.showAvatar = showAvatar
    self.avatarSize = avatarSize
    self.imagePreviewSize =
      imagePreviewSize
    self.videoPreviewSize =
      videoPreviewSize
    self.messageAlign = messageAlign
    self.senderAlign = senderAlign
    self.bubbleRadius = bubbleRadius
    self.bubblePadding = bubblePadding
    self.assets = assets
  }

  public static let `default`: Theme = Theme()
}
