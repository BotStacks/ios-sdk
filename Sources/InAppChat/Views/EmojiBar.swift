//
//  EmojiBar.swift
//  InAppChat
//
//  Created by Zaid Daghestani on 2/8/23.
//

import Foundation
import SwiftUI

public class UIMessageActions: UIViewController {
  
  @IBOutlet var emoji1: UIButton!
  @IBOutlet var emoji2: UIButton!
  @IBOutlet var emoji3: UIButton!
  @IBOutlet var emoji4: UIButton!
  @IBOutlet var emoji5: UIButton!
  @IBOutlet var more: UIButton!
  @IBOutlet var favoritesLabel: UILabel!
  
  var room: UIChatRoom!
  
  static let defaults = ["😀", "🤟", "❤️", "🔥", "🤣"]

  var buttons: [UIButton] {
    return [emoji1, emoji2, emoji3, emoji4, emoji5]
  }
  
  var emojis: [String] = []
  
  override public func viewDidLoad() {
    var emojis = Chats.current.lastUsedReactions
    if let current = room.messageForAction?.currentReaction {
      emojis.insert(current, at: 0)
      emojis = emojis.unique()
      if emojis.count > 5 {
        emojis.removeLast()
      }
    }
    for (i, btn) in buttons.enumerated() {
      let e = emojis[i]
      btn.setTitle(e, for: .normal)
      btn.layer.cornerRadius = 20.0
      if e == room.messageForAction?.currentReaction {
        btn.layer.borderWidth = 2.0
        btn.layer.borderColor = c().primary.cgColor
      }
    }
    self.emojis = emojis
    favoritesLabel.text = room.messageForAction?.favorite == true ? "Remove from favorites" : "Save to favorites"
  }
  
  @IBAction func tapEmoji(_ sender: UIButton) {
    if let i = buttons.firstIndex(of: sender) {
      room.messageForAction?.react(emojis[i])
      self.dismiss(animated: true)
    }
  }
  
  @IBAction func tapMore() {
    self.dismiss(animated: true)
    room.emojiKeyboard()
  }
  
  @IBAction func reply() {
    self.dismiss(animated: true)
    room.replyingTo = room.messageForAction
  }
  
  @IBAction func favorites() {
    room.messageForAction?.toggleFavorite()
    dismiss(animated: true)
  }
}

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
