//
//  RepliesView.swift
//  BotStacksChat
//
//  Created by Zaid Daghestani on 2/6/23.
//

import DynamicColor
import Foundation
import SwiftUI

public struct RepliesView: View {

  @Environment(\.iacTheme) var theme

  @ObservedObject var message: Message
  public init(message: Message) {
    self.message = message
  }

  public var body: some View {
    NavLink(to: message.path) {
      VStack {
        Text("#\(message.chat.displayName)")
          .font(theme.fonts.title3.font)
          .foregroundColor(theme.colors.text)
        Text(message.chat.activeMembers.map(\.user).usernames)
          .font(theme.fonts.body.font)
          .foregroundColor(
            theme.colors.caption
          )
        ForEach(message.replies.items, id: \.id) {
          MessageView(message: $0)
        }
        Spacer()
          .height(24)
        Spacer()
          .background(Color(DynamicColor(theme.colors.bubble).withAlphaComponent(0.5).cgColor))
          .height(20)
      }.padding(.horizontal, 16.0)
        .padding(.top, 12.0)
    }
  }
}
