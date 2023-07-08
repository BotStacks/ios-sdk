import Foundation
import SwiftUI


public struct ChannelsView: View {

  @Environment(\.iacTheme) var theme
  @ObservedObject var chats = Chats.current
  @Environment(\.geometry) var geometry
  @EnvironmentObject var pilot: UIPilot<Routes>

  @Binding var scrollToTop: Int
  public init(scrollToTop: Binding<Int>) {
    self._scrollToTop = scrollToTop
  }

  public var body: some View {
    ScrollViewReader { proxy in
      ZStack(alignment: .topLeading) {
        PagerList(
          pager: chats.network,
          topInset: geometry.insets.top + Header<EmptyView>.height,
          bottomInset: geometry.insets.bottom + Tabs.height,
          empty: {
            EmptyListView(
              loading: chats.network.loading,
              config: theme.assets.emptyAllChannels,
              tab: true,
              cta: CTA(icon: nil, text: "Create A Channel", action: {
                pilot.push(.CreateChat(id: nil))
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
          title: "All Channels", showStartMessage: false, showSearch: true, addPath: Routes.CreateChat(id: nil)
        )
      }
    }
  }
}
