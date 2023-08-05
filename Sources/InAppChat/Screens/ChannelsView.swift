import Foundation
import SwiftUI
import UIKit
import SDWebImage
import SnapKit

public struct ChannelsView: View {

  @Environment(\.iacTheme) var theme
  @ObservedObject var chats = Chats.current
  @Environment(\.geometry) var geometry
  @EnvironmentObject var navigator: Navigator

  @Binding var scrollToTop: Int
  public init(scrollToTop: Binding<Int>) {
    self._scrollToTop = scrollToTop
  }

  public var body: some View {
    ScrollViewReader { proxy in
      ZStack(alignment: .topLeading) {
        PagerList(
          pager: chats.network,
          topInset: geometry.insets.top + Header<EmptyView>.height + 20.0,
          bottomInset: geometry.insets.bottom + Tabs.height + 10.0,
          empty: {
            EmptyListView(
              loading: chats.network.loading,
              config: theme.assets.emptyAllChannels,
              tab: true,
              cta: CTA(icon: nil, text: "Create A Channel", action: {
                navigator.navigate("/groups/new")
              })
            )
          }
        ) { chat in
          ChannelRow(chat: chat)
        }.onChange(of: scrollToTop) { newValue in
          if let id = chats.network.items.first?.id {
            withAnimation {
              proxy.scrollTo(id, anchor: .top)
            }
          }
        }
        Header(
          title: "All Channels", showStartMessage: false, showSearch: true, addPath: "/groups/new"
        )
      }
    }
  }
}
