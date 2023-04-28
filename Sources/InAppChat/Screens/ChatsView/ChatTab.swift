//
//  Threads.swift
//  InAppChat
//
//  Created by Zaid Daghestani on 1/29/23.
//
import Foundation
import SwiftUI

public struct ChatTabView: View {

  @Environment(\.iacTheme) var theme
  @Environment(\.geometry) var geometry

  @Binding var current: Chats.List
  let tab: Chats.List
  let unreadCount: Int

  var selected: Bool {
    return current == tab
  }

  public var body: some View {
    return Button {
      current = tab
    } label: {
      HStack(alignment: .top) {
        if tab == .groups {
          Spacer()
        }
        VStack(spacing: 2) {
          Text(tab.rawValue)
            .font(theme.fonts.title2.bold())
            .foregroundColor(selected ? theme.colors.primary : theme.colors.caption)
          if selected {
            RoundedRectangle(cornerRadius: 2)
              .fill(theme.colors.primary)
              .height(4.0)
          }
        }.fixedSize()
        if unreadCount > 0 {
          ZStack {
            Badge(count: unreadCount)
          }.frame(width: 0, height: 20)
        }
        if tab == .threads {
          Spacer()
        }
      }.growX()
    }
  }

}

extension Color {
  static var random: Color {
    return [
      Color.red, Color.green, Color.blue, Color.cyan, Color.brown, Color.indigo, Color.mint,
      Color.orange, Color.pink, Color.purple, Color.teal,
    ].randomElement()!
  }
}
