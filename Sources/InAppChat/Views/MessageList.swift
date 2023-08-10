//
//  MessageLIst.swift
//  InAppChatUI
//
//  Created by Zaid Daghestani on 1/26/23.
//

import Foundation
import SwiftUI
import UIKit

public class UIMessageCell: UITableViewCell {
  
  var message: Message! {
    didSet {
      bindUI()
    }
  }
  
  weak var label: UILabel?
  
  func bindUI() {
    var md = message.markdownText
    for at in message.attachments ?? [] {
      switch at.type {
      case .image:
        
        break
      case .audio:
        break
      case .file:
        
        break
      case .location:
        md = at.loc?.markdownLink ?? ""
        break
      case .vcard:
        md = at.contact?.markdown ?? ""
        break
      case .video:
        break
      default:
        break
      }
    }
    if !md.isEmpty {
      
    }
  }
}


public class UIMessageList: UIViewController, UITableViewDelegate, UITableViewDataSource {
  
  @IBOutlet var tableView: UITableView!
  
  var chat: Chat? {
    didSet {
      if let chat = chat {
        messages = chat.sending + chat.items
      }
    }
  }

  var onLongPress: (Message) -> Void = {
    message in
    
  }
  
  var messages = Chats.current.favorites.items {
    didSet {
      tableView.reloadData()
    }
  }
  
  public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return messages.count
  }

  
  public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let msg = messages[indexPath.row]
    let cell = tableView.dequeueReusableCell(withIdentifier: "message")! as! UIMessageCell
    cell.message = msg
    return cell
  }
  
  public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
  }
  
}

public struct MessageList: View {

  @Environment(\.geometry) var geometry
  @ObservedObject var chat: Chat
  let onLongPress: (Message) -> Void

  public var body: some View {
    let items = (chat.sending + chat.items).reversed()
    ScrollViewReader { proxy in
      ScrollView {
        LazyVStack {
          Spacer().height(geometry.height)
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
          if newValue != nil {
            withAnimation {
              proxy.scrollTo("bottom", anchor: .bottom)
            }
          }
        }.onAppear {
          if chat.items.isEmpty {
            chat.loadMore()
          } else {
            Task.detached {
              try await chat.refresh()
            }
          }
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
          .font(theme.fonts.headline.font)
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
