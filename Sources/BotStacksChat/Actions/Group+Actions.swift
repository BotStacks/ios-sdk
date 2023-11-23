import Foundation

extension Chat {

  func dismissInvites() {
    if self.invites.isEmpty {
      return
    }
    let og = self.invites
    self.invites = []
    Task.detached {
      do {
        _ = try await api.dismissInvites(for: self.id)
      } catch let err {
        Monitoring.error(err)
        publish {
          self.invites = og
        }
      }
    }
  }

  func join() {
    if _private && !isInvited {
      return
    }
    if joining { return }
    joining = true
    let m = Member(
      chat_id: self.id,
      user_id: User.current!.id,
      created_at: Date(),
      role: MemberRole.member
    )
    members.append(m)
    Task {
      do {
        let membership = try await api.join(group: self.id)
        await MainActor.run {
          BotStacksChatStore.current.memberships.append(m)
        }
      } catch let err {
        Monitoring.error(err)
        await MainActor.run {
          self.members.removeAll(where: { $0.user_id == User.current!.id })
        }
      }
      await MainActor.run {
        self.joining = false
      }
    }
  }

  func leave() {
    if joining { return }
    joining = true
    Task {
      await self.asyncLeave()
    }
  }

  func asyncLeave() async {
    guard let me = self.membership, self.isMember else {
      return
    }
    await MainActor.run {
      self.members.remove(element: me)
        BotStacksChatStore.current.memberships.remove(element: me)
    }
    do {
      _ = try await api.leave(group: self.id)
    } catch let err {
      Monitoring.error(err)
      await MainActor.run {
        self.members.append(me)
          BotStacksChatStore.current.memberships.append(me)
      }
    }
    await MainActor.run {
      self.joining = false
    }
  }

  func update(
    name: String?,
    description: String?,
    image: URL?,
    _private: Bool?
  ) async throws {
    if updating {
      return
    }
    let ogName = self.name
    let ogDescription = self.description
    let ogImage = self.image
    let ogPrivate = self._private
    await MainActor.run {
      self.updating = true
      if let name = name {
        self.name = name
      }
      if let description = description {
        self.description = description
      }
      if let image = image {
        self.image = image.absoluteString
      }
      if let _private = _private {
        self._private = _private
      }
    }
    do {
      _ = try await api.update(
        group: self.id,
        name: name,
        description: description,
        image: image,
        _private: _private
      )
    } catch let err {
      Monitoring.error(err)
      
      await MainActor.run {
        self.name = ogName
        self.description = ogDescription
        self.image = ogImage
        self._private = ogPrivate
        self.updating = false
      }
      throw err
    }
    await MainActor.run {
      updating = false
    }
  }

  func delete() async throws {
    let _ = try await api.delete(group: self.id)
    await MainActor.run {
        BotStacksChatStore.current.cache.chats.removeValue(forKey: self.id)
      if let m = self.membership {
        BotStacksChatStore.current.memberships.remove(element: m)
      }
      if self.isDM, let friend = self.friend {
        BotStacksChatStore.current.cache.chatsByUID.removeValue(forKey: friend.id)
      }
      BotStacksChatStore.current.network.items.removeAll(where: {self.id == $0.id})
    }
  }

  func invite(users: [User]) {
    if inviting { return }
    inviting = true
    Task.detached {
      do {
        _ = try await api.invite(users: users.map(\.id), to: self.id)
      } catch let err {
        Monitoring.error(err)
      }
      publish {
        self.inviting = false
      }
    }
  }
}
