//
//  Avatar.swift
//  BotStacksChatUI
//
//  Created by Zaid Daghestani on 1/25/23.
//

import Foundation
import SwiftUI

public struct Avatar: View {

  @Environment(\.iacTheme) var theme

  public let url: String?
  public let size: CGFloat
  public let group: Bool

  public init(url: String?, size: CGFloat = 35.0, group: Bool = false) {
    self.url = url
    self.size = size
    self.group = group
  }

  public var body: some View {
    ZStack {
      if let url = url {
        GifImageView(url: url)
          .aspectRatio(contentMode: .fill)
          .size(size)
      } else {
        if group {
          GroupPlaceholder(size: size)
            .scaledToFit()
            .grow()
        } else {
          AssetImage("user-fill")
            .image
            .resizable()
            .scaledToFit()
            .size(18.0 * size / 35.0)
            .foregroundColor(theme.colors.text)
        }
      }
    }.size(size).background(theme.colors.softBackground).cornerRadius(size / 2.0)
//    .circle(size, theme.colors.softBackground)
  }
}
