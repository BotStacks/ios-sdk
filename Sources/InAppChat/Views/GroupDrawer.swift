//
//  GroupDrawer.swift
//  InAppChat
//
//  Created by Zaid Daghestani on 2/10/23.
//

import Foundation
import SwiftUI

public class UIGroupDrawer: UIViewController {
  var chat: Chat!
  
  override public func viewDidLoad() {
    
  }
}

public struct GroupDrawer: View {

  @Environment(\.iacTheme) var theme
  @Environment(\.geometry) var geometry
  @EnvironmentObject var navigator: Navigator
  @Environment(\.dismiss) var dismiss

  @ObservedObject var chat: Chat

  @State var delete = false
  @State var leave = false

  public init(_ chat: Chat) {
    self.chat = chat
  }

  public var body: some View {
    ActionSheet {
      ZStack(alignment: .bottom) {
        VStack(alignment: .leading, spacing: 0) {
          VStack(spacing: 0) {
            Spacer().height(24)
            if let image = chat.displayImage {
              GifImageView(url: image.url!)
                .circle(70, .clear)
            } else {
              GroupPlaceholder(size: 70)
            }
            Spacer().height(12)
            Text(chat.displayName)
              .font(theme.fonts.title2.font)
              .foregroundColor(theme.colors.text)
            Text(chat.description ?? "")
              .font(theme.fonts.body.font)
              .foregroundColor(theme.colors.caption)
            Spacer().height(26)
            Divider().overlay(theme.colors.text).opacity(0.1)
          }.padding(.horizontal, 64)
            .padding(.bottom, 24)
            .padding(.top, 24)
          HStack(spacing: 0) {
            Text("All Members")
              .font(theme.fonts.headline.font)
              .foregroundColor(theme.colors.text)
            Spacer().width(14)
            AssetImage("users-three-fill")
              .image
              .resizable()
              .size(16)
              .foregroundColor(theme.colors.caption)
            Text("\(chat.activeMembers.count)")
              .font(theme.fonts.caption.font)
              .foregroundColor(theme.colors.caption)
          }
          header("Admin")
          ForEach(chat.admins) { user in
            Button {
              dismiss()
              navigator.navigate(user.path)
            } label: {
              ContactRow(user: user)
            }
          }
          if !chat.onlineNotAdminUsers.isEmpty {
            header("members - online")
            ForEach(chat.onlineNotAdminUsers) { user in
              Button {
                dismiss()
                navigator.navigate(user.path)
              } label: {
                ContactRow(user: user)
              }
            }
          }
          if !chat.offlineUsers.isEmpty {
            header("members")
            ForEach(chat.offlineUsers) { user in
              Button {
                dismiss()
                navigator.navigate(user.path)
              } label: {
                ContactRow(user: user)
              }
            }
          }
          Spacer().height(geometry.insets.bottom + 72)
        }.listStyle(.plain)
          .listItemTint(.clear)
        HStack(spacing: 4) {
          if chat.isAdmin {
            Button {
              dismiss()
              navigator.navigate(chat.editPath)
            } label: {
              ZStack {
                VStack(spacing: 0) {
                  AssetImage("gear-fill")
                    .image
                    .resizable()
                    .size(24)
                    .foregroundColor(theme.colors.border)
                  Text("Edit")
                    .font(theme.fonts.mini.font)
                    .foregroundColor(theme.colors.border)
                }
              }.size(60)
            }
          }
          Button {
            dismiss()
            navigator.navigate(chat.invitePath)
          } label: {
            ZStack {
              VStack(spacing: 0) {
                AssetImage("archive-box-fill")
                  .image
                  .resizable()
                  .size(24)
                  .foregroundColor(theme.colors.border)
                Text("Invite")
                  .font(theme.fonts.mini.font)
                  .foregroundColor(theme.colors.border)
              }
            }.size(60)
          }
          Button {
            if chat.isAdmin {
              self.delete = true
            } else {
              self.leave = true
            }
          } label: {
            ZStack {
              VStack(spacing: 0) {
                AssetImage("trash-fill")
                  .image
                  .resizable()
                  .size(24)
                  .foregroundColor(theme.colors.border)
                Text(chat.isAdmin ? "Delete" : "Leave")
                  .font(theme.fonts.mini.font)
                  .foregroundColor(theme.colors.border)
              }
            }.size(60)
          }
        }.padding(.horizontal, 8)
          .height(60)
          .background(.thinMaterial)
          .cornerRadius(16)
      }.padding(.horizontal, 16)
    }.confirmationDialog("Are you sure you want to leave this channel?", isPresented: $leave) {
      Button("Leave \(chat.displayName)?", role: .destructive) {
        dismiss()
        chat.leave()
        navigator.goBack()
      }
    }.confirmationDialog("Are you sure you want to delete this channel?", isPresented: $delete) {
      Button("Delete \(chat.displayName)?", role: .destructive) {
        Task.detached {
          do {
            try await chat.delete()
            await MainActor.run {
              self.dismiss()
              navigator.goBack()
            }
          } catch let err {
            Monitoring.error(err)
          }
        }
      }
    }
  }

  func header(_ text: String) -> some View {
    return Text(text)
      .textCase(.uppercase)
      .font(theme.fonts.caption.font.bold())
      .foregroundColor(theme.colors.caption)
      .padding(.top, 24)
  }
}
