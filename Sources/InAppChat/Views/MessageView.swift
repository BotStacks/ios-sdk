import SwiftDate
import SwiftUI

public struct MessageView: View {

  @Environment(\.iacTheme) var theme
  @ObservedObject var message: Message
  @ObservedObject var user: User
  
  init(message: Message) {
    self.message = message
    self.user = message.user
  }

  func topStack() -> some View {
    return HStack(alignment: .bottom, spacing: 8.0) {
      Text(message.user.username)
        .font(theme.fonts.username.font)
        .foregroundColor(theme.colors.username)
        .frame(maxWidth: 120.0)
        .truncationMode(.tail)
      Text(message.createdAt.toString(.time(.short)))
        .font(theme.fonts.timestamp.font)
        .foregroundColor(theme.colors.timestamp)
    }.fixedSize()
  }

  func content() -> some View {
    return VStack(
      alignment: message.user.isCurrent == true ? theme.senderAlign : theme.messageAlign,
      spacing: 4.0
    ) {
      topStack()
      MessageContent(message: message)
      reactions()
      replyCount()
    }
  }

  func reactions() -> some View {
    return message.reactions.map { reactions in
      return HStack(spacing: 8.0) {
        ForEach(reactions, id: \.reaction) { reaction in
          Button {
            message.react(reaction.reaction)
          } label: {
            Text("\(reaction.reaction) \(reaction.uids.count)")
              .font(theme.fonts.body.font)
              .foregroundColor(theme.colors.text)
              .padding(theme.bubblePadding)
              .background(theme.colors.bubble.new())
              .cornerRadius(36.0)
              .fixedSize()
              .overlay(
                RoundedRectangle(
                  cornerRadius: 36
                ).stroke(
                  message.currentReaction == reaction.reaction ? theme.colors.primary : Color.clear,
                  lineWidth: 2)
              )
          }
        }
      }
    }
  }

  func replyCount() -> some View {
    return message.replyCount > 0
      ? Text("\(message.replyCount) replies")
        .foregroundColor(self.theme.colors.primary)
        .padding(4.0)
        .font(theme.fonts.body.font.bold())
      : nil
  }

  func favorite() -> some View {
    ZStack {
      AssetImage("star-fill")
        .image
        .resizable()
        .size(20.0)
        .foregroundColor(theme.colors.primary)
    }.size(35.0)
  }

  public var body: some View {
    let align =
      message.user.isCurrent == true
      ? self.theme.senderAlign : self.theme.messageAlign
    if user.blocked {
      EmptyView()
    } else {
      VStack(alignment: align) {
        HStack(alignment: .top, spacing: 10.0) {
          let align = message.user.isCurrent == true ? theme.senderAlign : theme.messageAlign
          let avatar = NavLink(to: message.user.path) {
            Avatar(url: message.user.avatar)
          }
          if align == .trailing {
            Spacer()
            content()
            
            if theme.showAvatar {
              avatar
            }
            if message.favorite {
              favorite()
            }
            if message.status == .sending {
              Spinner()
                .size(20)
            }
          } else {
            if message.status == .sending {
              Spinner()
                .size(20)
            }
            if message.favorite {
              favorite()
            }
            if theme.showAvatar {
              avatar
            }
            content()
            Spacer()
          }
        }.padding(.vertical, 5.0)
          .padding(.horizontal, 10.0)
      }.onAppear {
        message.markRead()
      }
    }
  }

}
