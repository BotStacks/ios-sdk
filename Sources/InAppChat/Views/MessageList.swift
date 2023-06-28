//
//  MessageLIst.swift
//  InAppChatUI
//
//  Created by Zaid Daghestani on 1/26/23.
//

import Foundation
import SwiftUI

public struct MessageList: View {

  @Environment(\.geometry) var geometry
  @ObservedObject var chat: Chat
  let onLongPress: (Message) -> Void

  public var body: some View {
    ScrollViewReader { proxy in
      PagerList(
        pager: thread,
        prefix: thread.sending,
        invert: true,
        topInset: geometry.insets.top + Header<Image>.height,
        bottomInset: geometry.insets.bottom + 70.0
      ) { message in
        MessageView(message: message)
          .onLongPressGesture {
            onLongPress(message)
          }
      }.height(geometry.height)
        .onChange(of: thread.sending.first?.id ?? thread.items.first?.id) { newValue in
          if let id = newValue {
            withAnimation {
              proxy.scrollTo(id, anchor: .bottom)
            }
          }
        }
    }
  }
}


public struct RepliesList: View {

  @Environment(\.geometry) var geometry
  @Environment(\.iacTheme) var theme
  @ObservedObject var chat: Chat
  @ObservedObject var message: Message
  @ObservedObject var replies: RepliesPager
  let onLongPress: (Message) -> Void
  
  public init(_ thread: Thread, message: Message, onLongPress: @escaping (Message) -> Void) {
    self.thread = thread
    self.message = message
    self.replies = message.replies
    self.onLongPress = onLongPress
  }

  public var body: some View {
    ScrollViewReader { proxy in
      VStack {
        Text("Reply Thread")
          .foregroundColor(theme.colors.caption)
          .font(theme.fonts.headline)
        MessageView(message: message).background(.thinMaterial)
        PagerList(
          pager: replies,
          prefix: thread.sending.filter({$0.parent?.id == message.id}),
          invert: true,
          topInset: geometry.insets.top + Header<Image>.height,
          bottomInset: geometry.insets.bottom + 70.0
        ) { message in
          MessageView(message: message)
            .onLongPressGesture {
              onLongPress(message)
            }
        }
        .onChange(of: thread.sending.first?.id ?? thread.items.first?.id) { newValue in
          if let id = newValue {
            withAnimation {
              proxy.scrollTo(id, anchor: .bottom)
            }
          }
        }
      }
    }
  }
}
