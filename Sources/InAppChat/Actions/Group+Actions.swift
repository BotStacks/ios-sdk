import Foundation

extension Group {

  func dismissInvites() {
    if self.invites.isEmpty {
      return
    }
    let og = self.invites
    self.invites = []
    Task.detached {
      do {
        _ = try await api.dismissInvites(for: self)
      } catch let err {
        Monitoring.error(err)
        publish {
          self.invites = og
        }
      }
    }
  }

  func join() {
    if joining { return }
    joining = true
    participants.append(
      Participant(
        appUserId: User.current!.email, eRTCUserId: User.current!.id, role: .user,
        joinedAtDate: Date()))
    Task {
      do {
        if self.invites.isEmpty {
          _ = try await api.join(group: self)
        } else {
          _ = try await api.accept(invite: self)
        }
      } catch let err {
        Monitoring.error(err)
        await MainActor.run {
          self.participants.removeAll(where: { $0.eRTCUserId == User.current!.id })
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
    guard let me = self.participants.first(where: { $0.eRTCUserId == User.current?.id }) else {
      return
    }
    await MainActor.run {
      self.participants.remove(element: me)
    }
    do {
      _ = try await api.join(group: self)
      await MainActor.run {
        if let thread = Thread.get(group: self.id) {
          Chats.current.groups.items.removeAll(where: { $0.id == thread.id })
        }
        print("left group")
      }
    } catch let err {
      Monitoring.error(err)
      await MainActor.run {
        self.participants.append(me)
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
  ) async {
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
        group: self,
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
      }
    }
    await MainActor.run {
      updating = false
    }
  }

  func delete() async throws {
    try await api.delete(group: self)
    Chats.current.cache.groups.removeValue(forKey: self.id)
    if let thread = Thread.get(group: self.id) {
      Chats.current.cache.threadsByGroup.removeValue(forKey: self.id)
      Chats.current.cache.threads.removeValue(forKey: thread.id)
      Chats.current.groups.items.removeAll(where: { thread.id == $0.id })
      Chats.current.network.items.removeAll(where: { thread.id == $0.id })
    }
  }

  func invite(users: [User]) {
    if inviting { return }
    inviting = true
    Task.detached {
      do {
        _ = try await api.invite(users: users, to: self)
      } catch let err {
        Monitoring.error(err)
      }
      publish {
        self.inviting = false
      }
    }
  }
}
