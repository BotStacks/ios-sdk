//
//  IACMainRoutes.swift
//  25519
//
//  Created by Zaid Daghestani on 2/3/23.
//

import Foundation
import SwiftUI

public struct IACMainRoutes<Routes>: View where Routes: View {

  let initialPath: String
  let routes: () -> Routes

  public init(
    initialPath: String = "/chats", @ViewBuilder routes: @escaping () -> Routes = { EmptyView() }
  ) {
    self.initialPath = initialPath
    self.routes = routes
  }

  public var body: some View {
    return AnyView(
      Router(initialPath: initialPath) {
        ViewLog()
        SwiftUI.Group {
          AnyView(
            Route("chat/:id") { info in
              ChatRoute(cid: info.parameters["id"] ?? "")
            })
          AnyView(
            Route("user/:id/chat") { info in
              ChatRoute(uid: info.parameters["id"] ?? "")
            })
          AnyView(
            Route("user/:id") { info in
              Profile(id: info.parameters["id"] ?? User.current?.id ?? "")
            })
          AnyView(
            Route("chats/new") {
              NewChat()
            })
          AnyView(
            Route("search") {
              Search()
            })
          AnyView(
            Route("profile") {
              Profile(id: User.current?.id ?? "")
            })
          AnyView(
            Route("favorites") {
              FavoritesView()
            })
          AnyView(
            Route("settings/notifications") {
              ManageNotifications()
            })
          AnyView(
            Route("chats") {
              Tabs("/chats")
            })
          AnyView(
            Route("channels") {
              Tabs("/channels")
            })
        }
        SwiftUI.Group {
          AnyView(
            Route("groups/new/invite") {
              InviteUsers()
            })
          AnyView(
            Route("group/:id/invite") { info in
              InviteUsers(chatID: info.parameters["id"])
            })
          AnyView(
            Route("groups/new") {
              CreateChat()
            })
          AnyView(
            Route("contacts") {
              Tabs("/contacts")
            })
          AnyView(
            Route("settings") {
              Tabs("/settings")
            })
          AnyView(
            Route("group/:id/edit") { info in
              CreateChat(info.parameters["id"])
            })
        }
        routes()
      })
  }
}

extension IACMainRoutes where Routes == EmptyView {
  public init(initialPath: String) {
    self.init(initialPath: initialPath, routes: { EmptyView() })
  }
}
