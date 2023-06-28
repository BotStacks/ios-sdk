//
//  InviteUsers.swift
//  InAppChat
//
//  Created by Zaid Daghestani on 2/9/23.
//

import Foundation
import SwiftUI

public struct InviteUsers: View {

  @ObservedObject var chats = Chats.current
  @Environment(\.geometry) var geometry
  @Environment(\.iacTheme) var theme
  @EnvironmentObject var navigator: Navigator

  let chat: Chat?
  let state = CreateGroupState.current

  @State var selected: [User] = []
  @State var creating = false

  public init(chatID: String? = nil) {
    self.chat = chatID.flatMap({ Chat.get($0) })
  }

  public var body: some View {
    ZStack(alignment: .topLeading) {
      VStack {
        PagerList(
          pager: chats.contacts,
          topInset: geometry.insets.top + Header<EmptyView>.height
        ) { contact in
          Button {
            if selected.contains(contact) {
              selected.remove(element: contact)
            } else {
              selected.append(contact)
            }
          } label: {
            HStack {
              ContactRow(user: contact)
              ZStack {
                Image(systemName: "checkmark")
                  .resizable()
                  .scaledToFit()
                  .tint(theme.colors.background)
                  .size(14)
              }.circle(25, selected.contains(contact) ? theme.colors.primary : theme.colors.caption)
            }.padding(.trailing, 16)
          }
        }.height(geometry.height - geometry.insets.bottom - 60.0)
        HStack(spacing: 22.0) {
          Button {
            navigator.goBack()
          } label: {
            ZStack {
              Image(systemName: "chevron.left")
                .resizable()
                .scaledToFit()
                .size(20)
                .tint(theme.colors.background)

            }.circle(50, theme.inverted.softBackground)
          }
          Button {
            if let group = group {
              group.invite(users: selected)
              navigator.goBack()
            } else if !creating, let state = state {
              self.creating = true
              Task.detached {
                do {
                  let group = try await api.createGroup(
                    name: state.name,
                    description: state.description,
                    image: state.image,
                    private: state._private
                  )
                  await group.invite(users: self.selected)
                  await MainActor.run {
                    CreateGroupState.current = nil
                    navigator.goBack(total: 2)
                    navigator.navigate(group.path)
                  }
                } catch let err {
                  Monitoring.error(err)
                  await MainActor.run {
                    creating = false
                  }
                }
              }
            }
          } label: {
            ZStack {
              HStack {
                if group?.inviting == true || creating {
                  Spinner()
                    .size(30)
                    .foregroundColor(.white)
                }
                Text(group != nil ? "Send Invites" : "Create My Channel")
                  .font(theme.fonts.headline)
                  .foregroundColor(theme.colors.background)
              }
            }
            .growX()
            .height(50)
            .background(theme.colors.primary)
            .cornerRadius(25)
          }
        }.padding(.horizontal, 16.0)
      }.padding(.bottom, geometry.insets.bottom + 12.0)
      Header(title: "Invite Users")
    }.onAppear {
      print("Render invite users with geometry", geometry)
    }
  }
}
