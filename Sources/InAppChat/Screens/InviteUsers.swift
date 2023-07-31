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
  @EnvironmentObject var pilot: UIPilot<Routes>

  let chat: Chat?
  let state = CreateChatState.current

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
            pilot.pop()
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
            if let chat = chat {
              chat.invite(users: selected)
              pilot.pop()
            } else if !creating, let state = state {
              self.creating = true
              Task.detached {
                do {
                  let chat = try await api.createChat(
                    name: state.name,
                    description: state.description,
                    image: state.image,
                    private: state._private ,
                    invites: self.selected.map(\.id)
                  )
                  await chat.invite(users: self.selected)
                  await MainActor.run {
                    CreateChatState.current = nil
                    pilot.popTo(.Tabs)
                    pilot.push(chat.path)
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
                if chat?.inviting == true || creating {
                  Spinner()
                    .size(30)
                    .foregroundColor(.white)
                }
                Text(chat != nil ? "Send Invites" : "Create My Channel")
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
