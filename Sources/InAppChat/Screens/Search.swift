//
//  Search.swift
//  InAppChat
//
//  Created by Zaid Daghestani on 2/6/23.
//

import Foundation
import SwiftUI

public struct Search: View {

  @Environment(\.iacTheme) var theme
  @Environment(\.geometry) var geometry

  @FocusState var focus
  @State var text = ""
  var chat: Chat?

  public init(id: String? = nil) {
    self.chat = id.flatMap { Chat.get($0) }
  }

  public var body: some View {
    VStack {
      Header(title: "Search")
      HStack(spacing: 0) {
        TextField("Search messages...", text: $text)
          .background(.clear)
          .font(theme.fonts.body)
          .growX()
          .focused($focus)
      }
      .padding(.leading, 14)
      .height(44.0)
      .background(theme.colors.softBackground)
      .cornerRadius(22)
      Spacer()
    }.grow()
  }
}
