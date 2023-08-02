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
  
  let tab: T
  
  init(tab: T) {
    self.tab = tab
  }

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
  
  
  var tabView: some View {
    switch tab {
    case .channels:
      return AnyView(ChannelsView(scrollToTop: $scrollToTop))
    case .chats:
      return AnyView(ChatsView(scrollToTop: $scrollToTop, onExploreChannels: {
        print("On Explore Channels")
        navigator.navigate(path(T.channels), replace: true)
      }, onSendAMessage: {
        navigator.navigate(path(T.contacts), replace: true)
      }))
    case .contacts:
      return AnyView(ContactsView(scrollToTop: $scrollToTop))
    case .settings:
      return AnyView(MyProfile())
    }
  }

  public var body: some View {
    ZStack(alignment: .bottom) {
      tabView
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
                .foregroundColor(t == tab ? theme.colors.primary : theme.colors.text)
                .size(45)
            }.grow()
          }.grow()
        }
      }.growX()
        .frame(height: Tabs.height)
        .padding(.bottom, geometry.insets.bottom)
        .background(.thinMaterial)
    }.grow().edgesIgnoringSafeArea(.all)
  }
}
