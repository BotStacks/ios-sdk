//
//  Tabs.swift
//  InAppChat
//
//  Created by Zaid Daghestani on 2/1/23.
//

import Foundation
import SwiftUI

public struct Tabs: View {

  static let height = 57.0

  @Environment(\.iacTheme) var theme
  @Environment(\.geometry) var geometry
  @EnvironmentObject private var navigator: Navigator
  @State var scrollToTop = 0

  enum T: String {
    case chats = "chat-text-fill"
    case channels = "television-fill"
    case contacts = "address-book-fill"
    case settings = "user-circle-fill"

    static let all: [T] = [.chats, .channels, .contacts, .settings]

    static func path(_ path: String) -> T {
      switch path {
      case "/chats":
        return .chats
      case "/channels":
        return .channels
      case "/contacts":
        return .contacts
      case "/settings":
        return .settings
      default:
        return .chats
      }
    }
  }

  let tab: T

  public init(_ path: String) {
    self.tab = .path(path)
  }

  func path(_ tab: T) -> String {
    switch tab {
    case .chats:
      return "/chats"
    case .channels:
      return "/channels"
    case .settings:
      return "/settings"
    case .contacts:
      return "/contacts"
    }
  }

  public var body: some View {
    ZStack(alignment: .bottom) {
      SwitchRoutes {
        Route("/chats") {
          ChatsView(scrollToTop: $scrollToTop)
        }
        Route("/channels") {
          ChannelsView(scrollToTop: $scrollToTop)
        }
        Route("/contacts") {
          ContactsView(scrollToTop: $scrollToTop)
        }
        Route("/settings") {
          MyProfile()
        }
      }
      HStack {
        ForEach(T.all, id: \.rawValue) { t in
          Button {
            if tab == t {
              scrollToTop += 1
            } else {
              navigator.navigate(path(t), replace: true)
            }
          } label: {
            ZStack {
              AssetImage(t.rawValue)
                .resizable()
                .scaledToFit()
                .foregroundColor(t == tab ? theme.colors.primary : theme.colors.caption)
                .size(45)
            }.grow()
          }.grow()
        }
      }.growX()
        .frame(height: Tabs.height)
        .padding(.bottom, geometry.insets.bottom)
        .background(.thinMaterial)
    }.grow()
  }
}
