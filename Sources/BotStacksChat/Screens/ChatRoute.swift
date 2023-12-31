//
//  UserChat.swift
//  BotStacksChat
//
//  Created by Zaid Daghestani on 2/3/23.
//

import Foundation
import SwiftUI

public struct ChatRoute: View {
  let uid: String?
  let cid: String?
  let mid: String?
  @State var user: User? = nil
  @State var chat: Chat? = nil
  @State var message: Message? = nil
  @State var failed = false

  public init(uid: String? = nil, cid: String? = nil, mid: String? = nil) {
    print("Chat Route \(uid ?? "nouid") \(cid ?? "nocid") \(mid ?? "nomid")")
    self.uid = uid
    self.cid = cid
    self.mid = mid
    if let uid = uid {
      _user = State(initialValue: User.get(uid))
      let t = Chat.get(uid: uid)
      _chat = State(initialValue: t)
      if t == nil {
        fetchUser(_user.wrappedValue?.id ?? uid)
      }
    }
    if let cid = cid {
      let c = Chat.get(cid)
      _chat = State(initialValue: c)
      if c == nil {
        fetchChat(cid)
      }
    }
    if let mid = mid {
      let m = Message.get(mid)
      _message = State(initialValue: m)
      let t = m?.chat
      _chat = State(initialValue: t)
      if m == nil {
        fetchMessage(mid)
      } else if t == nil {
        fetchChat(m!.chatID)
      }
    }
//    print("Have chat \(chat?.id ?? "none")")
  }
  
  func fetchMessage(_ id: String) {
    print("Fetch Message")
    Task.detached {
      do {
        let m = try await api.get(message: id)
        await MainActor.run {
          self.message = m
          self.chat = m.chat
        }
      } catch let err {
        Monitoring.error(err)
        await MainActor.run {
          self.failed = true
        }
      }
    }
  }
  
  func fetchChat(_ id: String) {
    print("Fetch Chat")
    Task.detached {
      do {
        print("Chat Route Fetch Chat")
        let t = try await api.get(chat: id)
        await MainActor.run {
          self.chat = t
        }
      } catch let err {
        Monitoring.error(err)
        await MainActor.run {
          self.failed = true
        }
      }
    }
  }
  
  func fetchUser(_ id: String) {
    print("Fetch user chat")
    Task.detached {
      do {
        let chat = try await api.dm(user: id)
        await MainActor.run {
          self.chat = chat
        }
      } catch let err {
        Monitoring.error(err)
        await MainActor.run {
          failed = true
        }
      }
    }
  }


  @Environment(\.iacTheme) var theme
  
  var logChat: some View {
    print("Render chat room with chat \(self.chat?.id)")
    return EmptyView()
  }

  public var body: some View {
    logChat
    if let chat = chat ?? cid.flatMap({Chat.get($0)}) ?? uid.flatMap({Chat.get(uid: $0)}) {
      ChatRoom(chat: chat, message: message)
    } else {
      VStack {
        Header<Image>(title: user?.username ?? "")
        ZStack {
          if failed {
            Text("Chat not found")
              .font(theme.fonts.title2Regular.font)
              .multilineTextAlignment(
                .center
              )
              .foregroundColor(
                theme.colors.text
              )
          } else {
            Spinner()
              .size(64)
          }
        }.padding(.all, 32).grow()
      }.grow()
    }
  }
}
