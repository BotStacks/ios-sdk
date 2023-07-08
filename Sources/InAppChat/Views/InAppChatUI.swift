//
//  InAppChatUI.swift
//  InAppChatUI
//
//  Created by Zaid Daghestani on 1/25/23.
//

import Foundation
import GiphyUISDK
import SwiftUI

public enum Style {
  case full
}

public struct InAppChatUI: View {

  @Environment(\.colorScheme) var colorScheme
  let theme: Theme
  let style: Style

  public init(
    theme: Theme = Theme.default,
    style: Style = .full
  ) {
    self.theme = theme
    self.style = style

    UITableView.appearance().backgroundColor = .clear
    UITableView.appearance().separatorStyle = .none
    UICollectionView.appearance().backgroundColor = .clear
  }
  
  @ViewBuilder
  func ui() -> some View {
    switch (style) {
    case .full:
      InAppChatFull()
    }
  }

  public var body: some View {
    GeometryReader { proxy in
      ui()
        .background(theme.with(colorScheme).colors.background.new())
        .edgesIgnoringSafeArea(.all)
        .environment(\.geometry, Geometry(size: proxy.size, insets: proxy.safeAreaInsets))
        .environment(\.iacTheme, theme.with(colorScheme))
        .preferredColorScheme(colorScheme)
        .buttonStyle(.borderless)
    }
  }
}
