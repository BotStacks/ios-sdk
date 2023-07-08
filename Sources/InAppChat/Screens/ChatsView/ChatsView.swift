//
//  Threads.swift
//  InAppChat
//
//  Created by Zaid Daghestani on 1/29/23.
//

import Foundation
import SwiftUI

public struct ChatsView: View {

  @State var list: Chats.List = .groups
  @ObservedObject var chats = Chats.current

  @Environment(\.iacTheme) var theme
  @Environment(\.geometry) var geometry

  @Binding var scrollToTop: Int
  
  let onExploreChannels: () -> Void
  let onSendAMessage: () -> Void
  public init(scrollToTop: Binding<Int>, onExploreChannels: @escaping () -> Void, onSendAMessage: @escaping () -> Void) {
    self._scrollToTop = scrollToTop
    self.onExploreChannels = onExploreChannels
    self.onSendAMessage = onSendAMessage
  }
  
  func currentCta() -> CTA {
    switch list {
    case .groups:
      return CTA(
        icon: nil,
        text: "Explore Channels",
        action: onExploreChannels
      )
    case .users:
      return CTA(
        icon: AssetImage("paper-plane-tilt-fill"),
        text: "Send a Message",
        action: onSendAMessage
      )
    }
  }
  
  

  public var body: some View {
    ScrollViewReader { proxy in
      ZStack(alignment: .topLeading) {
        let empty = {
          EmptyListView(
            loading: chats.loading,
            config: theme.assets.list(list),
            tab: true,
            extraHeight: -44.0,
            cta: currentCta()
          )
        }
        let header = {
          HStack(spacing: 0) {
            ForEach(Chats.List.all, id: \.rawValue) {
              ChatTabView(
                current: $list,
                tab: $0,
                unreadCount: chats.count($0)
              )
              .growX()
            }
          }.height(44.0)
        }
        IACList(
          items: list == .groups ? chats.groups : chats.dms,
          divider: true,
          topInset: geometry.insets.top + Header<EmptyView>.height,
          bottomInset: geometry.insets.bottom + Tabs.height,
          header: header,
          empty: empty,
          content: { ThreadRow(chat: $0) }
        )
        
        Header(title: "Message", showStartMessage: true, showSearch: true)
      }.onChange(of: scrollToTop) { newValue in
        var id:String? = nil
        switch list {
        case .users:
          id = chats.dms.first?.id
        case .groups:
          id = chats.groups.first?.id
        }
        if let id = id {
          withAnimation {
            proxy.scrollTo(id, anchor: .top)
          }
        }
      }
    }
  }
}
