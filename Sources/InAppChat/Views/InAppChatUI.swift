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

public struct InAppChatUI<Content>: View where Content: View {
  
  @Environment(\.colorScheme) var colorScheme
  let theme: Theme
  let content: () -> Content
  
  public init(
    theme: Theme = Theme.default,
    @ViewBuilder content: @escaping () -> Content = { IACMainRoutes() }
  ) {
    self.theme = theme
    self.content = content
    Theme.current = theme
    UITableView.appearance().backgroundColor = .clear
    UITableView.appearance().separatorStyle = .none
    UICollectionView.appearance().backgroundColor = .clear
  }
  
  public var body: some View {
    GeometryReader { proxy in
      (theme.with(colorScheme).colors.background.new())
        .edgesIgnoringSafeArea(.all)
      content()
        .environment(\.geometry, Geometry(size: proxy.size, insets: proxy.safeAreaInsets))
        .environment(\.iacTheme, theme.with(colorScheme))
        .preferredColorScheme(colorScheme)
        .buttonStyle(.borderless)
        .navigationBarHidden(true)
        .navigationTitle(Text("Chat"))
        .edgesIgnoringSafeArea(.all)
    }
  }
}
