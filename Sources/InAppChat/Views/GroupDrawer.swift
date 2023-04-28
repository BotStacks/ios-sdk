//
//  GroupDrawer.swift
//  InAppChat
//
//  Created by Zaid Daghestani on 2/10/23.
//

import Foundation
import SwiftUI

public struct GroupDrawer: View {

  @Environment(\.iacTheme) var theme
  @Environment(\.geometry) var geometry
  @EnvironmentObject var navigator: Navigator
  @Environment(\.dismiss) var dismiss

  @ObservedObject var group: Group

  @State var delete = false
  @State var leave = false

  public init(_ group: Group) {
    self.group = group
  }

  public var body: some View {
    ActionSheet {
      ZStack(alignment: .bottom) {
        VStack(alignment: .leading, spacing: 0) {
          VStack(spacing: 0) {
            Spacer().height(24)
            if let image = group.image {
              GifImageView(url: try! image.asURL())
                .circle(70, .clear)
            } else {
              GroupPlaceholder().size(70)
            }
            Spacer().height(12)
            Text(group.name)
              .font(theme.fonts.title2)
              .foregroundColor(theme.colors.text)
            Text(group.description ?? "")
              .font(theme.fonts.body)
              .foregroundColor(theme.colors.caption)
            Spacer().height(26)
            Divider().overlay(theme.colors.text).opacity(0.1)
          }.padding(.horizontal, 64)
            .padding(.bottom, 24)
            .padding(.top, 24)
          HStack(spacing: 0) {
            Text("All Members")
              .font(theme.fonts.headline)
              .foregroundColor(theme.colors.text)
            Spacer().width(14)
            AssetImage("users-three-fill")
              .resizable()
              .size(16)
              .foregroundColor(theme.colors.caption)
            Text("\(group.participants.count)")
              .font(theme.fonts.caption)
              .foregroundColor(theme.colors.caption)
          }.padding(.leading, 16)
          List {
            header("Admin")
            ForEach(group.admins) { user in
              Button {
                dismiss()
                navigator.navigate(user.path)
              } label: {
                ContactRow(user: user)
              }
            }
            header("members - online")
            ForEach(group.onlineNotAdminUsers) { user in
              Button {
                dismiss()
                navigator.navigate(user.path)
              } label: {
                ContactRow(user: user)
              }
            }
            header("members")
            ForEach(group.offlineUsers) { user in
              Button {
                dismiss()
                navigator.navigate(user.path)
              } label: {
                ContactRow(user: user)
              }
            }
            Spacer().height(geometry.insets.bottom + 72)
          }.listStyle(.plain)
            .listItemTint(.clear)
        }
        HStack(spacing: 4) {
          if group.isAdmin {
            Button {
              dismiss()
              navigator.navigate(group.editPath)
            } label: {
              ZStack {
                VStack(spacing: 0) {
                  AssetImage("gear-fill")
                    .resizable()
                    .size(24)
                    .foregroundColor(theme.colors.border)
                  Text("Edit")
                    .font(theme.fonts.mini)
                    .foregroundColor(theme.colors.border)
                }
              }.size(60)
            }
          }
          Button {
            dismiss()
            navigator.navigate(group.invitePath)
          } label: {
            ZStack {
              VStack(spacing: 0) {
                AssetImage("archive-box-fill")
                  .resizable()
                  .size(24)
                  .foregroundColor(theme.colors.border)
                Text("Invite")
                  .font(theme.fonts.mini)
                  .foregroundColor(theme.colors.border)
              }
            }.size(60)
          }
          Button {
            if group.isAdmin {
              self.delete = true
            } else {
              self.leave = true
            }
          } label: {
            ZStack {
              VStack(spacing: 0) {
                AssetImage("trash-fill")
                  .resizable()
                  .size(24)
                  .foregroundColor(theme.colors.border)
                Text(group.isAdmin ? "Delete" : "Leave")
                  .font(theme.fonts.mini)
                  .foregroundColor(theme.colors.border)
              }
            }.size(60)
          }
        }.padding(.horizontal, 8)
          .height(60)
          .background(.thinMaterial)
          .cornerRadius(16)
      }
    }.confirmationDialog("Are you sure you want to leave this channel?", isPresented: $leave) {
      Button("Leave \(group.name)?", role: .destructive) {
        dismiss()
        group.leave()
        navigator.goBack()
      }
    }.confirmationDialog("Are you sure you want to delete this channel?", isPresented: $delete) {
      Button("Delete \(group.name)?", role: .destructive) {
        Task.detached {
          do {
            try await group.delete()
            await MainActor.run {
              self.dismiss()
              self.navigator.goBack()
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
      .font(theme.fonts.caption.bold())
      .foregroundColor(theme.colors.caption)
      .padding(.top, 24)
  }
}
