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
    let items = (chat.sending + chat.items).reversed()
    ScrollViewReader { proxy in
      ScrollView {
        LazyVStack {
          Spacer()
          Spacer().height(geometry.insets.top + Header<Image>.height)
          ForEach(items,  id: \.id) { message in
            MessageView(message: message)
              .onLongPressGesture {
                onLongPress(message)
              }.onAppear {
                chat.loadMoreIfNeeded(message)
              }
          }
          Spacer().height(geometry.insets.bottom + 70.0).id("bottom")
        }.frame(minHeight: geometry.height)
      }
        .height(geometry.height)
        .onChange(of: items.last?.id) { newValue in
          if let id = newValue {
            withAnimation {
              proxy.scrollTo("bottom", anchor: .bottom)
            }
          }
        }.onAppear {
          chat.loadMoreIfEmpty()
          proxy.scrollTo("bottom", anchor: .bottom)
        }.edgesIgnoringSafeArea(.all)
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
  
  public init(_ chat: Chat, message: Message, onLongPress: @escaping (Message) -> Void) {
    self.chat = chat
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
          prefix: chat.sending.filter({$0.parent?.id == message.id}),
          invert: true,
          topInset: geometry.insets.top + Header<Image>.height,
          bottomInset: geometry.insets.bottom + 70.0
        ) { message in
          MessageView(message: message)
            .onLongPressGesture {
              onLongPress(message)
            }
        }
        .onChange(of: chat.sending.first?.id ?? chat.items.first?.id) { newValue in
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
