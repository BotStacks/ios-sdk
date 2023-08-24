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
      InAppChatStore.current.hiddenUsers.append(self.id)
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
