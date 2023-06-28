//
//  ManageNotifications.swift
//  InAppChat
//
//  Created by Zaid Daghestani on 2/1/23.
//

import Foundation
import SwiftUI

public struct ManageNotifications: View {

  @ObservedObject var settings = Chats.current.settings
  @Environment(\.iacTheme) var theme

  public init() {}

  public var body: some View {
    VStack(alignment: .leading, spacing: 0.0) {
      Header(title: "Manage Notifications")
      HStack {
        Text("Notification status")
          .font(theme.fonts.body)
          .foregroundColor(theme.colors.text)
      }.padding(.leading, 16.0)
      Spacer().height(20.0)
      Button {
        settings.setNotification(.all)
        print("new notifications", settings.notifications)
      } label: {
        Option(title: "Allow All", selected: settings.notifications == .all)
      }
      Button {
        settings.setNotification(.mentions)
        print("new notifications", settings.notifications)
      } label: {
        Option(title: "Mentions Only", selected: settings.notifications == .mentions)
      }
      Button {
        settings.setNotification(.none)
        print("new notificaitons", settings.notifications)
      } label: {
        Option(title: "None", selected: settings.notifications == .none)
      }
      Spacer()
      Button {

      } label: {
        ZStack {
          Text("Update")
            .textCase(.uppercase)
            .foregroundColor(theme.colors.background)
            .font(theme.fonts.headline)
        }
        .height(60)
        .growX()
        .background(theme.colors.primary)
        .cornerRadius(15.0)
      }.padding(.horizontal, 16.0)
    }.padding(.bottom, 16.0).edgesIgnoringSafeArea(.top)
  }

}

private struct Option: View {
  @Environment(\.iacTheme) var theme
  let title: String
  let selected: Bool

  var body: some View {
    HStack {
      Text(title)
        .font(theme.fonts.headline)
        .foregroundColor(theme.colors.text)
      Spacer()
      IACRadio(selected: selected)
    }.height(64)
      .padding(.horizontal, 16)
  }
}
