//
//  EmojiBar.swift
//  InAppChat
//
//  Created by Zaid Daghestani on 2/8/23.
//

import Foundation
import SwiftUI

public struct EmojiBar: View {

  static let defaults = ["😀", "🤟", "❤️", "🔥", "🤣"]

  @Environment(\.geometry) var geometry
  @Environment(\.iacTheme) var theme
  let currentEmoji: String?
  let emojis: [String]
  let onEmoji: (String) -> Void
  let onEmojiKeyboard: () -> Void

  public init(
    currentEmoji: String? = nil,
    onEmoji: @escaping (String) -> Void,
    onEmojiKeyboard: @escaping () -> Void
  ) {
    self.currentEmoji = currentEmoji
    var emojis = Chats.current.lastUsedReactions
    if let current = currentEmoji {
      emojis.insert(current, at: 0)
      emojis = emojis.unique()
      if emojis.count > 5 {
        emojis.removeLast()
      }
    }
    self.emojis = emojis
    self.onEmoji = onEmoji
    self.onEmojiKeyboard = onEmojiKeyboard
  }

  public var body: some View {
    HStack {
      ForEach(emojis, id: \.self) { emoji in
        Button {
          onEmoji(emoji)
        } label: {
          ZStack {
            Text(emoji)
              .font(.system(size: 18))
          }.circle(40, theme.colors.softBackground)
            .overlay(
              RoundedRectangle(cornerRadius: 20.0)
                .stroke(currentEmoji == emoji ? theme.colors.primary : .clear, lineWidth: 2.0)
            )
        }
        Spacer()
      }
      Button {
        onEmojiKeyboard()
      } label: {
        ZStack {
          AssetImage("emoji-add").image
            .resizable()
            .foregroundColor(theme.colors.text)
            .size(24.0)
        }.circle(40, theme.colors.softBackground)
      }
    }
  }

}
