
extension Message {
  
  func decr(_ reaction: String) {
    if let i = self.reactions?.firstIndex(where: {$0.emojiCode == reaction}) {
      let r = self.reactions![i]
      let users = r.users.filter({$0 != User.current!.id})
      if !users.isEmpty {
        self.reactions![i] = Reaction(emojiCode: reaction, count: users.count, users: users)
      } else {
        self.reactions?.remove(at: i)
      }
    }
  }

  func markRead() {
    if user.isCurrent == true {
      return
    }
    if self.thread?.group != nil {
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
    self.reacting = true
    let isSet = reaction != currentReaction
    self.reactions = self.reactions ?? []
    let og = self.reactions ?? []
    let ogCurrent = self.currentReaction
    if isSet {
      if let i = self.reactions?.firstIndex(where: { $0.emojiCode == reaction }) {
        let r = self.reactions![i]
        var users = r.users
        users.append(User.current!.id)
        users = users.unique()
        self.reactions![i] = Reaction(emojiCode: reaction, count: users.count, users:users)
      } else {
        self.reactions?.append(Reaction(emojiCode: reaction, count: 1, users: [User.current!.id]))
      }
      if let current = currentReaction {
        decr(current)
      }
      self.currentReaction = reaction
      Chats.current.onReaction(reaction)
    } else {
      decr(reaction)
      self.currentReaction = nil
    }
    Task.detached {
      do {
        _ = try await api.react(to: self, reaction: reaction, set: isSet)
      } catch let err {
        Monitoring.error(err)
        if !preview {
          publish {
            self.currentReaction = ogCurrent
            self.reactions = og
          }
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
        if !preview {
          publish {
            self.favorite = !self.favorite
          }
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
        _ = try await api.edit(message: self, text: text)
      } catch let err {
        Monitoring.error(err)
        if !preview {
          publish {
            self.text = og
          }
        }
      }
      publish {
        self.editingText = false
      }
    }
  }

  func delete() {
    Thread.get(self.threadID)?.items.remove(element: self)
    Chats.current.cache.messages.removeValue(forKey: self.id)
    Task.detached {
      do {
        _ = try await api.delete(message: self)
      } catch let err {
        Monitoring.error(err)
      }
    }
  }
}
