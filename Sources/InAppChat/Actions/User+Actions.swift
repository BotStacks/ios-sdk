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
        try await api.block(user: self, isBlock: self.blocked)
        Chats.current.settings.setBlock(self.id, self.blocked)
      } catch let err {
        Monitoring.error(err)
        if !preview {
          publish {
            self.blocked = !self.blocked
          }
        }
      }
      publish {
        self.blocking = false
      }
    }
  }
}
