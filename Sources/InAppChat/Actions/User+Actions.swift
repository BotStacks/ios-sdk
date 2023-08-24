//
//  User+Actions.swift
//  InAppChat
//
//  Created by Zaid Daghestani on 2/1/23.
//

import Foundation

extension User {
  func block() {
    if blocking { return }
    blocking = true
    blocked = !blocked
    Task.detached {
      do {
        if self.blocked {
          let _ = try await api.block(user: self.id)
        } else {
          let _ = try await api.unblock(user: self.id)
        }
        InAppChatStore.current.settings.setBlock(self.id, self.blocked)
        if self.blocked {
          InAppChatStore.current.hiddenUsers.insert(self.id)
          await MainActor.run {
            InAppChatStore.current.memberships.removeAll(where: {$0.chat.isDM && $0.chat.friend?.id == self.id})
            if let ms = Message.byUid[self.id] {
              for id in ms {
                if let m = Message.get(id) {
                  m.chat.items.remove(element: m)
                }
              }
            }
          }
        } else {
          InAppChatStore.current.hiddenUsers.remove(self.id)
          await MainActor.run {
            if let c = InAppChatStore.current.cache.chatsByUID[self.id], let m = c.membership {
              InAppChatStore.current.memberships.append(m)
            }
            if let ms = Message.byUid[self.id] {
              var chats = Set<String>()
              for id in ms {
                if let m = Message.get(id), !m.chat.items.contains(m) {
                  m.chat.items.append(m)
                  chats.insert(m.chatID)
                }
              }
              for id in chats {
                if let c = Chat.get(id) {
                  c.items = c.items.sorted(by: sortMessages)
                }
              }
            }
          }
        }
      } catch let err {
        Monitoring.error(err)
        publish {
          self.blocked = !self.blocked
        }
      }
      publish {
        self.blocking = false
      }
    }
  }
  
  func hide() {
    if !isCurrent {
      InAppChatStore.current.hiddenUsers.insert(self.id)
      InAppChatStore.current.contacts.items.remove(element: self)
    }
  }
  
  func flag(_ reason: String) {
    hide()
    Task.detached {
      do {
        try await api.flag(input:.init(reason: reason, user: .some(self.id)))
      } catch let err {
        Monitoring.error(err)
        print(err)
      }
    }
  }
}
