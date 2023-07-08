//
//  IACMainRoutes.swift
//  25519
//
//  Created by Zaid Daghestani on 2/3/23.
//

import Foundation
import SwiftUI

public enum Routes: Equatable {
  case Tabs
  case Profile(id: String?)
  case Chat(id: String, isUser: Bool)
  case NewChat
  case Search
  case Favorites
  case ManageNotifications
  case InviteUsers(id: String?)
  case CreateChat(id: String?)
  case Message(String)
}

public struct InAppChatFull: View {

  @StateObject var pilot = UIPilot(initial: Routes.Tabs)
  
  public init() {}
  
  public var body: some View {
    return UIPilotHost(pilot) { route in
      switch route {
      case .Tabs: Tabs()
      case .Chat(let id, let isUser): ChatRoute(uid: isUser ? id: nil, cid: isUser ? nil : id)
      case .Profile(let id): Profile(id: id ?? User.current?.id ?? "")
      case .NewChat: NewChat()
      case .Search: Search()
      case .Favorites: FavoritesView()
      case .ManageNotifications: ManageNotifications()
      case .InviteUsers(let id): InviteUsers(chatID: id)
      case .CreateChat(let id): CreateChat(id)
      case .Message(let id): ChatRoute(mid: id)
      }
    }.uipNavigationBarHidden(true).edgesIgnoringSafeArea(.all).navigationBarBackButtonHidden(true)
  }
}
