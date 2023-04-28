//
//  ThreadRow.swift
//  InAppChat
//
//  Created by Zaid Daghestani on 1/28/23.
//

import SwiftDate
import SwiftUI

private let formatter = RelativeDateTimeFormatter()

public struct ThreadRow: View {

  @StateObject var thread: Thread
  @Environment(\.iacTheme) var theme

  public var body: some View {
    NavLink(to: thread.path) {
      HStack(alignment: .center, spacing: 0.0) {
        ZStack {
          Circle().fill(
            thread.isUnread
              ? theme.colors.unread
              : theme
                .colors
                .softBackground
          )
          if thread.isUnread {
            Circle().inset(by: 2.0)
              .fill(theme.colors.softBackground)
          }
          Avatar(
            url: thread.user?.avatar ?? thread.group?.image,
            size: 46.0
          )
        }.size(60.0)
        VStack(alignment: .leading, spacing: 0.0) {
          HStack {
            Text(thread.user?.displayName ?? thread.user?.username ?? thread.group?.name ?? "")
              .font(theme.fonts.title3)
              .truncationMode(.tail)
              .foregroundColor(theme.colors.text)
              .lineLimit(1)
            if let group = thread.group {
              PrivacyPill(_private: group._private)
            }
          }
          HStack {
            if thread.latest?.status == .seen {
              Image(systemName: "checkmark.circle.fill")
                .resizable()
                .foregroundColor(theme.colors.primary)
                .size(12.0)
            }
            Text(
              thread.latest?.summary ?? "No messages yet"
            ).lineLimit(1)
              .foregroundColor(
                thread.isUnread ? theme.colors.text : theme.colors.caption
              )
              .font(theme.fonts.body)
          }
        }.padding(.leading, 14.0)
        Spacer(minLength: 18.0)
        VStack(alignment: .trailing) {
          if let message = thread.latest {
            Text(
              message.createdAt >= Date() - 3.hours
              ? message.createdAt.toRelative(since: nil, dateTimeStyle: .numeric, unitsStyle: .short)
                : message.createdAt.isToday
                  ? message.createdAt.toString(.time(.short))
                  : message.createdAt.toRelative(
                    since: nil, dateTimeStyle: .numeric, unitsStyle: .short)
            )
            .foregroundColor(theme.colors.caption)
            .font(theme.fonts.body)
          }
          if thread.isUnread {
            Badge(count: thread.unreadCount)
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
