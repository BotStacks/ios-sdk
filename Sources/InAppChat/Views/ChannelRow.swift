import Foundation
import SwiftUI

func groupInvitesText(group: Group) -> String {
  return "**\(group.invites.map({$0}).usernames)** invited you to join!"
}

public struct ChannelRow: View {

  @ObservedObject var group: Group
  @Environment(\.iacTheme) var theme

  public var body: some View {
    if group.isMember || !group._private {
      return AnyView(
        NavLink(to: group.path) {
          row
        })
    } else {
      return AnyView(row)
    }
  }

  public var row: some View {
    VStack {
      VStack {
        if group.hasInvite {
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
                .init(groupInvitesText(group: group))
              ).foregroundColor(.white)
                .font(theme.fonts.body)
                .multilineTextAlignment(.leading)
              Spacer()
              Button {
                group.dismissInvites()
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
          NavLink(to: "/group/\(group.id)") {
            HStack {
              if let image = group.image {
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
                  Text(group.name)
                    .lineLimit(1)
                    .font(theme.fonts.title3)
                  PrivacyPill(_private: group._private)
                }
                Text(group.description ?? "")
                  .lineLimit(2)
                  .font(theme.fonts.body)
                  .foregroundColor(theme.colors.caption)
                  .multilineTextAlignment(.leading)
                Spacer(minLength: 0)
                HStack {
                  GroupCount(count: group.participants.count)
                  Spacer()
                }
              }.padding(.leading, 13.0)
            }
          }.growX()
            .padding(8.0)
            .height(103.0)
          if !group._private || group.isMember || group.hasInvite {
            Button {
              if group.isMember {
                group.leave()
              } else {
                group.join()
              }
            } label: {
              Image(systemName: "plus.circle.fill")
                .resizable()
                .foregroundColor(
                  group.isMember ? theme.colors.caption : theme.colors.primary
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
