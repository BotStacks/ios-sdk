extension Message {

  func markRead() {
    if !self.chat.isDM {
      return
    }
    if self.status != .seen {
      self.status = .seen
      Task {
        do {
          try await api.markRead(self)
        } catch let err {
          Monitoring.error(err)
        }
      }
    }
  }

  func react(_ reaction: String) {
    if reacting {
      return
    }
    print("React to \(text) with \(reaction)")
    self.reacting = true
    self.reactions = self.reactions ?? []
    let og = self.reactions ?? []
    let ogCurrent = self.currentReaction
    let action = react_impl(uid: User.current!.id, reaction: reaction, reactions: &reactions!)
    if action != .delete {
      InAppChatStore.current.onReaction(reaction)
    }
    Task.detached {
      do {
        _ = try await api.react(to: self.id, reaction: reaction)
      } catch let err {
        Monitoring.error(err)
        publish {
          self.currentReaction = ogCurrent
          self.reactions = og
        }
      }
      publish {
        self.reacting = false
      }
    }
  }

  func toggleFavorite() {
    if favoriting { return }
    favoriting = true
    self.favorite = !self.favorite
    Task.detached {
      do {
        _ = try await api.favorite(message: self, add: self.favorite)
      } catch let err {
        Monitoring.error(err)
        publish {
          self.favorite = !self.favorite
        }
      }
      publish {
        self.favoriting = false
      }
    }
  }

  func edit(text: String) {
    if editingText { return }
    editingText = true
    let og = self.text
    self.text = text
    Task.detached {
      do {
        _ = try await api.edit(message: self.id, text: text)
      } catch let err {
        Monitoring.error(err)
        publish {
          self.text = og
        }
      }
      publish {
        self.editingText = false
      }
    }
  }

  func delete() {
    Chat.get(self.chatID)?.items.remove(element: self)
    InAppChatStore.current.cache.messages.removeValue(forKey: self.id)
    Task.detached {
      do {
        _ = try await api.delete(message: self.id)
      } catch let err {
        Monitoring.error(err)
      }
    }
  }
  
  func hide() {
    if !user.isCurrent {
      InAppChatStore.current.hiddenMessages.insert(self.id)
      chat.items.remove(element: self)
    }
  }
  
  func flag(_ reason: String) {
    hide()
    Task.detached {
      do {
        try await api.flag(input:.init(message: .some(self.id), reason: reason))
      } catch let err {
        Monitoring.error(err)
        print(err)
      }
    }
  }
}
