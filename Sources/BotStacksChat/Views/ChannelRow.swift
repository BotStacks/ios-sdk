import Foundation
import SwiftUI
import UIKit
import SDWebImage
import Combine

func chatInvitesText(chat: Chat) -> String {
  return "**\(chat.invites.map({$0}).usernames)** invited you to join!"
}

public class UIChannelRow: UITableViewCell {
  
  var bag = Set<AnyCancellable>()

  var chat: Chat! {
    didSet {
      bag.forEach { $0.cancel() }
      bag.removeAll()
      chat.objectWillChange.makeConnectable().autoconnect()
        .sink { [weak self] _ in
          DispatchQueue.main.async {
            self?.bindUI()
          }
        }.store(in: &bag)
      bindUI()
      bindTheme()
    }
  }
  
  deinit {
    bag.forEach {$0.cancel()}
    bag.removeAll()
  }
  
  @IBOutlet var title: UILabel!
  @IBOutlet var subtitle: UILabel!
  @IBOutlet var count: UILabel!
  @IBOutlet var join: UIButton!
  @IBOutlet var pub: UIPrivacyPill!
  @IBOutlet var placeholder: UIGroupPlaceholder!
  @IBOutlet var avatar: SDAnimatedImageView!
  @IBOutlet var invites: UILabel!
  @IBOutlet var buttonDismissInvites: UIButton!
  @IBOutlet var invitesContainer: UIView!
  @IBOutlet var invitesContainerHeight: NSLayoutConstraint!
  
  func bindTheme() {
    title.font = Theme.current.fonts.title3
    subtitle.font = Theme.current.fonts.body
    subtitle.textColor = Theme.current.colors.caption.ui
    count.textColor = Theme.current.colors.text.ui
    contentView.subviews.first?.backgroundColor = Theme.current.colors.bubble.ui
  }
  
  func bindUI() {
    title.text = chat.displayName
    subtitle.text = chat.description
    count.text = String(chat.activeMembers.count)
//    join.backgroundColor = chat.isMember ? Theme.current.colors.caption.ui : Theme.current.colors.primary.ui
    pub.bind(chat: chat)
    if let url = chat.image {
      avatar.isHidden = false
      avatar.sd_setImage(with: url.url)
      placeholder.isHidden = true
    } else {
      placeholder.isHidden = false
      avatar.isHidden = true
    }
    join.tintColor = chat.isMember ? Theme.current.colors.caption.ui : Theme.current.colors.primary.ui
    if chat.isInvited {
      invites.attributedText = NSAttributedString(try! AttributedString(markdown: chatInvitesText(chat: chat)))
      if invites.superview == nil {
        invitesContainer.addSubview(invites)
        invitesContainer.addSubview(buttonDismissInvites)
      }
      invitesContainerHeight.isActive = false
      invitesContainer.backgroundColor = c().unread.ui
    } else {
      invites.removeFromSuperview()
      buttonDismissInvites.removeFromSuperview()
      invitesContainerHeight.isActive = true
      invitesContainer.backgroundColor = .clear
    }
  }
  
  @IBAction func tapJoin() {
    if chat.isMember {
      chat.leave()
    } else {
      chat.join()
    }
  }
  
  @IBAction func dismissInvites() {
    chat.dismissInvites()
  }
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
                .font(theme.fonts.body.font)
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
                GroupPlaceholder(size: 87)
                  .cornerRadius(15.0)
              }

              VStack(alignment: .leading, spacing: 0) {
                HStack(alignment: .center) {
                  Text(chat.displayName)
                    .lineLimit(1)
                    .font(theme.fonts.title3.font)
                  PrivacyPill(_private: chat._private)
                }
                Text(chat.description ?? "")
                  .lineLimit(2)
                  .font(theme.fonts.body.font)
                  .foregroundColor(theme.colors.caption)
                  .multilineTextAlignment(.leading)
                Spacer(minLength: 0)
                HStack {
                  ChatCount(count: chat.activeMembers.count)
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

public struct ChatCount: View {
  
  let count: Int
  @Environment(\.iacTheme) var theme
  
  public var body: some View {
    Text("\(count)")
      .foregroundColor(theme.colors.text)
  }
}
