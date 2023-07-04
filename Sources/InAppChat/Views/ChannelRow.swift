import Foundation
import SwiftUI

func chatInvitesText(chat: Chat) -> String {
  return "**\(chat.invites.map({$0}).usernames)** invited you to join!"
}

public struct ChannelRow: View {

  @ObservedObject var chat: Chat
  @Environment(\.iacTheme) var theme

  public var body: some View {
    if chat.isMember || !chat._private {
      return AnyView(
        NavLink(to: chat.path) {
          row
        })
    } else {
      return AnyView(row)
    }
  }

  public var row: some View {
    VStack {
      VStack {
        if chat.hasInvite {
          ZStack {
            LinearGradient(
              colors: [
                Color(hex: 0xC74848),
                Color(hex: 0xE34141),
              ],
              startPoint: .leading,
              endPoint: .trailing
            )
            HStack {
              Text(
                .init(chatInvitesText(chat: chat))
              ).foregroundColor(.white)
                .font(theme.fonts.body)
                .multilineTextAlignment(.leading)
              Spacer()
              Button {
                chat.dismissInvites()
              } label: {
                ZStack {
                  Image(systemName: "xmark")
                    .resizable()
                    .foregroundColor(.white)
                    .size(16.0)
                }
              }
            }.padding(.all, 10.0)
          }.frame(minHeight: 40.0)
        }

        ZStack(alignment: .bottomTrailing) {
          NavLink(to: "/chat/\(chat.id)") {
            HStack {
              if let image = chat.image {
                GifImageView(url: image)
                  .size(87)
                  .cornerRadius(15.0)
              } else {
                GroupPlaceholder()
                  .size(87)
                  .cornerRadius(15.0)
              }

              VStack(alignment: .leading, spacing: 0) {
                HStack(alignment: .center) {
                  Text(chat.name)
                    .lineLimit(1)
                    .font(theme.fonts.title3)
                  PrivacyPill(_private: chat._private)
                }
                Text(chat.description ?? "")
                  .lineLimit(2)
                  .font(theme.fonts.body)
                  .foregroundColor(theme.colors.caption)
                  .multilineTextAlignment(.leading)
                Spacer(minLength: 0)
                HStack {
                  ChatCount(count: chat.participants.count)
                  Spacer()
                }
              }.padding(.leading, 13.0)
            }
          }.growX()
            .padding(8.0)
            .height(103.0)
          if !chat._private || chat.isMember || chat.hasInvite {
            Button {
              if chat.isMember {
                chat.leave()
              } else {
                chat.join()
              }
            } label: {
              Image(systemName: "plus.circle.fill")
                .resizable()
                .foregroundColor(
                  chat.isMember ? theme.colors.caption : theme.colors.primary
                )
                .size(24)
            }.padding(8)
          }
        }
      }
      .background(theme.colors.bubble)
      .cornerRadius(15.0)
    }
    .padding(.horizontal, 16)
  }
}
