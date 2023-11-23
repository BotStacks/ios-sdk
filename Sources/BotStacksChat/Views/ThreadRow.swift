//
//  ThreadRow.swift
//  BotStacksChat
//
//  Created by Zaid Daghestani on 1/28/23.
//

import SwiftDate
import SwiftUI
import UIKit
import SDWebImage
import Combine

private let formatter = RelativeDateTimeFormatter()

public struct ThreadRow: View {

  @StateObject var chat: Chat
  @Environment(\.iacTheme) var theme

  public var body: some View {
    NavLink(to: chat.path) {
      HStack(alignment: .center, spacing: 0.0) {
        ZStack {
          Circle().fill(
            chat.isUnread
              ? theme.colors.unread
              : theme
                .colors
                .softBackground
          )
          if chat.isUnread {
            Circle().inset(by: 2.0)
              .fill(theme.colors.softBackground)
          }
          Avatar(
            url: chat.displayImage,
            size: 46.0
          )
        }.size(60.0)
        VStack(alignment: .leading, spacing: 0.0) {
          HStack {
            Text(chat.displayName)
              .font(theme.fonts.title3.font)
              .truncationMode(.tail)
              .foregroundColor(theme.colors.text)
              .lineLimit(1)
            if chat.isGroup {
              PrivacyPill(_private: chat._private)
            }
          }
          HStack {
            if chat.latestMessage?.status == .seen {
              Image(systemName: "checkmark.circle.fill")
                .resizable()
                .foregroundColor(theme.colors.primary)
                .size(12.0)
            }
            Text(
              chat.latestMessage?.summary ?? "No messages yet"
            ).lineLimit(1)
              .foregroundColor(
                chat.isUnread ? theme.colors.text : theme.colors.caption
              )
              .font(theme.fonts.body.font)
          }
        }.padding(.leading, 14.0)
        Spacer(minLength: 18.0)
        VStack(alignment: .trailing) {
          if let message = chat.latestMessage {
            Text(
              message.createdAt >= Date() - 3.hours
              ? message.createdAt.toRelative(since: nil, dateTimeStyle: .numeric, unitsStyle: .short)
                : message.createdAt.isToday
                  ? message.createdAt.toString(.time(.short))
                  : message.createdAt.toRelative(
                    since: nil, dateTimeStyle: .numeric, unitsStyle: .short)
            )
            .foregroundColor(theme.colors.caption)
            .font(theme.fonts.body.font)
          }
          if chat.isUnread {
            Badge(count: chat.unreadCount)
          }
        }
      }
      .padding(.vertical, 12.0)
      .padding(.leading, 16.0)
      .padding(.trailing, 16.0)
      .growX()
      .height(84.0)
    }
  }

}


public class UIThreadRow: UITableViewCell {
  
  @IBOutlet var groupPlaceholder: UIGroupPlaceholder!
  @IBOutlet var avatar: SDAnimatedImageView!
  @IBOutlet var title: UILabel!
  @IBOutlet var subtitle: UILabel!
  
  @IBOutlet var publicPrivate: UIPrivacyPill!
  
  @IBOutlet var timestamp: UILabel!
  
  @IBOutlet var unreadCount: BadgeSwift!
  
  @IBOutlet var unreadCircle: UIView!
  
  var bag: Set<AnyCancellable> = Set()
  
  var chat: Chat! {
    didSet {
      bag.forEach { it in
        it.cancel()
      }
      bag.removeAll()
      chat.objectWillChange.makeConnectable().autoconnect().sink { [weak self] _ in
        DispatchQueue.main.async {
          self?.bindUI()
        }
      }.store(in: &bag)
      bindUI()
    }
  }
  
  deinit {
    bag.forEach {  $0.cancel() }
    bag.removeAll()
  }
  
  override public func awakeFromNib() {
    bindTheme()
  }
  
  func bindTheme() {
    unreadCircle.layer.borderColor = Theme.current.colors.unread.cgColor
    title.textColor = Theme.current.colors.text.ui
    subtitle.textColor = Theme.current.colors.text.ui
    unreadCount.badgeColor = c().unread.ui
    publicPrivate.titleLabel?.font = Theme.current.fonts.mini
  }
  
  func bindUI() {
    title.text = chat.displayName
    subtitle.text = chat.latestMessage?.summary
    if chat.unreadCount > 0 {
      unreadCount.text = String(chat.unreadCount)
      unreadCircle.layer.borderWidth = 2.0
      subtitle.textColor = Theme.current.colors.text.ui
      unreadCount.isHidden = false
    } else {
      unreadCircle.layer.borderWidth = 0.0
      subtitle.textColor = Theme.current.colors.caption.ui
      unreadCount.isHidden = true
    }
    if let image = chat.image {
      avatar.sd_setImage(with: image.url)
      avatar.isHidden = false
      groupPlaceholder.isHidden = true
    } else {
      avatar.isHidden = true
      groupPlaceholder.isHidden = false
    }
    publicPrivate.bind(chat: chat)
    if let message = chat.latestMessage {
      timestamp.isHidden = false
      timestamp.text = message.createdAt >= Date() - 3.hours
      ? message.createdAt.toRelative(since: nil, dateTimeStyle: .numeric, unitsStyle: .short)
      : message.createdAt.isToday
      ? message.createdAt.toString(.time(.short))
      : message.createdAt.toRelative(
        since: nil, dateTimeStyle: .numeric, unitsStyle: .short)
    } else {
      timestamp.isHidden = true
    }
  }
}
