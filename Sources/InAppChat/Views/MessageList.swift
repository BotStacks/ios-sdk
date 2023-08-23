//
//  MessageLIst.swift
//  InAppChatUI
//
//  Created by Zaid Daghestani on 1/26/23.
//

import Foundation
import SwiftUI
import UIKit
import Combine

public class UIMessageList: UIViewController, UITableViewDelegate, UITableViewDataSource {
  
  @IBOutlet var tableView: UITableView!
  
  var bag = Set<AnyCancellable>()
  
  var chat: Chat? {
    didSet {
      bag.forEach({$0.cancel()})
      bag.removeAll()
      if let chat = chat {
        print("MessageList did set chat")
        chat.objectWillChange.makeConnectable()
          .autoconnect()
          .throttle(for: 0.1, scheduler: RunLoop.main, latest: true)
          .sink(receiveValue: { [weak self] _ in
            DispatchQueue.main.async {
              self?.messages = chat.sending + chat.items
            }
          }).store(in: &bag)
        messages = chat.sending + chat.items
        chat.sub.sink { [weak self] _ in
          
        } receiveValue: { [weak self] id in
          DispatchQueue.main.async {
            if let id = id as? String {
              self?.updateReactionsForMessage(id)
            }
          }
        }.store(in: &bag)

      }
    }
  }
  
  func updateReactionsForMessage(_ id: String) {
    print("Update reactions for message", id)
    if let i = cells.lastIndex(where: {$0.1.id == id}) {
      if i > 0 {
        if cells[i - 1].0 == "reactions" {
          let ip = IndexPath(row: i - 1, section: 0)
          if cells[i].1.reactions == nil || cells[i].1.reactions?.isEmpty == true {
            cells.remove(at: ip.row)
            tableView.deleteRows(at: [ip], with: .fade)
          } else {
            tableView.reloadRows(at: [ip], with: .fade)
          }
        } else {
          cells.insert(("reactions", cells[i].1), at: i)
          tableView.insertRows(at: [IndexPath(row: i, section: 0)], with: .fade)
        }
      } else {
        cells.insert(("reactions", cells[i].1), at: 0)
        let ip = IndexPath(row: 0, section: 0)
        tableView.insertRows(at: [ip], with: .fade)
      }
    }
  }
  
  var pager: Pager<Message> {
    return chat ?? InAppChatStore.current.favorites
  }

  var onLongPress: (Message) -> Void = {
    message in
    
  }
  
  var onPress: (Message) -> Void = {
    message in
    
  }
  
  var onPressUser: (User) -> Void = {
    user in

  }
  
  var onTapReplies: (Message) -> Void = {
    message in
  }
  
  var messages = InAppChatStore.current.favorites.items {
    didSet {
      cells = messages.flatMap({ message in
        var ret: [(String, Message)] = []
        if message.replyCount > 0 {
          ret.append(("replies", message))
        }
        if message.reactions?.isEmpty == false {
          ret.append(("reactions", message))
        }
        ret.append( ("message", message))
        return ret
      })
      if viewIfLoaded != nil {
        tableView.reloadData()
      }
    }
  }

  var cells: [(String, Message)] = []
  
  override public func viewDidLoad() {
    super.viewDidLoad()
    if chat != nil {
      tableView.transform = CGAffineTransform(rotationAngle: -CGFloat.pi);
    } else {
      InAppChatStore.current.favorites.objectWillChange.makeConnectable()
        .autoconnect()
        .throttle(for: 0.1, scheduler: RunLoop.main, latest: true)
        .sink(receiveValue: { [weak self] _ in
          DispatchQueue.main.async {
            self?.messages = self?.pager.items ?? []
          }
        }).store(in: &bag)
    }
  }
  
  public override func viewDidLayoutSubviews() {
    tableView.scrollIndicatorInsets = .init(top: 0.0, left: 0.0, bottom: 0.0, right: tableView.bounds.size.width - 8.0)
  }
  
  override public func viewDidAppear(_ animated: Bool) {
    self.pager.loadMoreIfEmpty()
  }
  
  public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    print("Message LIst number of row \(messages.count)")
    return cells.count
  }
  
  public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    let cell = cells[indexPath.row]
    if cell.0 == "reactions" {
      return 34.0
    } else if cell.0 == "replies" {
      return 28.0
    } else {
      let m = cell.1
      var md = m.text ?? ""
      if let at = m.attachments?.first {
        switch at.type {
        case .image:
        fallthrough
        case .file:
          return Theme.current.imagePreviewSize.height + 38.0
        case .video:
          fallthrough
        case .audio:
          return Theme.current.videoPreviewSize.height + 38.0
        case .location:
          if let loc = at.loc?.markdownLink {
            md = loc
          }
        case .vcard:
          if let contact = at.contact?.markdown {
            md = contact
          }
        default:
          print("unknown cell type")
        }
      }
      let str = NSAttributedString((try? AttributedString(markdown: md)) ?? AttributedString(md))
      let width = tableView.frame.size.width - 32.0 - (m.favorite ? 24.0 : 0.0) - 35.0 - 8.0
      let rect = str.boundingRect(with: .init(width: width, height: CGFloat.greatestFiniteMagnitude), context: nil)
      return rect.height + 58.0
    }
  }
  
  public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let data = cells[indexPath.row]
    if data.0 == "reactions" {
      let cell = tableView.dequeueReusableCell(withIdentifier: "reactions") as! UIReactionsView
      cell.message = data.1
      if chat != nil {
        cell.transform = CGAffineTransform(rotationAngle: CGFloat.pi);
      }
      return cell
    } else if data.0 == "replies" {
      let cell = tableView.dequeueReusableCell(withIdentifier: "replies") as! UIRepliesCell
      cell.message = data.1
      if chat != nil {
        cell.transform = CGAffineTransform(rotationAngle: CGFloat.pi);
      }
      return cell
    }
    let msg = data.1
    let cell = tableView.dequeueReusableCell(withIdentifier: UIMessageRow.identifier(for: msg))! as! UIMessageRow
    cell.message = msg
    cell.onPressUser = onPressUser
    cell.onTapReplies = onTapReplies
    if chat != nil {
      cell.transform = CGAffineTransform(rotationAngle: CGFloat.pi);
    }
    return cell
  }
  
  public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let cell = cells[indexPath.row]
    if cell.0 == "reactions" {
      return
    }
    if cell.0 == "replies" {
      onTapReplies(cell.1)
    } else {
      onPress(cell.1)
    }
  }
  
  @IBAction func handleLongPress(_ sender: UILongPressGestureRecognizer) {
    let p = sender.location(in: tableView)
    if let i = tableView.indexPathForRow(at: p) {
      let cell = cells[i.row]
      onLongPress(cell.1)
    }
  }
  
  public func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    let m = cells[indexPath.row]
    if m.0 == "message" {
      pager.loadMoreIfNeeded(m.1)
    }
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
              await chat.refresh()
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
