import Contacts
import Photos
import PhotosUI

extension Chat {

  func send(_ text: String, inReplyTo: Message?) {
    let m = Message.init(
      id: UUID().uuidString,
      createdAt: Date(),
      userID: User.current!.id,
      chatID: self.id,
      parent: inReplyTo,
      text: text,
      reactions: [],
      status: .sending
    )
    self.sending.insert(m, at: 0)
    Task.detached {
      do {
        let newMessage = try await api.send(
          id: m.id,
          text: text,
          to: self.id,
          inReplyTo: inReplyTo?.id
        )
        await MainActor.run {
          self.sending.remove(element: m)
          if !self.items.contains(where: {$0.id == newMessage.id}) {
            self.items.insert(newMessage, at: 0)
          }
        }
      } catch let err {
        Monitoring.error(err)
        publish {
          self.sending.remove(element: m)
          m.status = .failed
          self.failed.append(m)
        }
      }
    }
  }

  func send(attachment: Gql.AttachmentInput, inReplyTo: Message?, message: Message? = nil) {
    let m = message ?? Message.init(
      id: UUID().uuidString,
      createdAt: Date(),
      userID: User.current!.id,
      chatID: self.id,
      parent: inReplyTo,
      text: "",
      attachments: [attachment.attachment],
      reactions: [],
      status: .sending
    )
    if message == nil {
      self.sending.insert(m, at: 0)
    }
    Task.detached {
      do {
        let newMessage = try await api.send(
          id: m.id,
          attachment: attachment,
          to: self.id,
          inReplyTo: inReplyTo?.id
        )
        publish {
          self.sending.remove(element: m)
          if !self.items.contains(where: {$0.id == newMessage.id}) {
            self.items.insert(newMessage, at: 0)
          }
        }
      } catch let err {
        Monitoring.error(err)
        publish {
          self.sending.remove(element: m)
          m.status = .failed
          self.failed.append(m)
        }
      }
    }
  }

  func send(file: File, type: Gql.AttachmentType, inReplyTo: Message?) {
    let m = Message.init(
      id: UUID().uuidString,
      createdAt: Date(),
      userID: User.current!.id,
      chatID: self.id,
      parent: inReplyTo,
      text: "",
      attachments: [Gql.AttachmentInput.init(id: UUID().uuidString, type: .case(type), url: file.url.absoluteString).attachment],
      reactions: [],
      status: .sending
    )
    self.sending.insert(m, at: 0)
    Task.detached {
      do {
        print("upload file \(file.url)")
        let url = try await api.uploadFile(file: file)
        print("Result \(url)")
        DispatchQueue.main.async {
          self.send(attachment: .init(id: UUID().uuidString, type: .case(type), url: url), inReplyTo: inReplyTo, message: m)
        }
      } catch let err {
        Monitoring.error(err)
        print("Failed to upload image")
      }
    }
  }

  func sendLocation(inReplyTo: Message?) {
    Task.detached {
      do {
        let location = try await LocationUtil.fetch()
        self.send(attachment:
            .init(id: UUID().uuidString, latitude: .some(location.latitude), longitude: .some(location.longitude), type: .case(.location), url: "data"),
                  inReplyTo: inReplyTo
        )
      } catch let err {
        print("Location", err)
      }
    }
  }

  func send(contact: CNContact, inReplyTo: Message?) {
    self.send(attachment: .init(data: .some(contact.toAppContact()), id: UUID().uuidString, type: .case(.vcard), url: "data"), inReplyTo: inReplyTo)
  }

  func markRead() {
    self.unreadCount = 0
    Task.detached {
      do {
        try await api.markChatRead(self.id)
      } catch let err {
        Monitoring.error(err)
      }
    }
  }
  
  
  func hide() {
    BotStacksChatStore.current.hiddenChats.append(self.id)
    BotStacksChatStore.current.memberships.removeAll(where: {$0.chat.id == self.id})
    BotStacksChatStore.current.network.items.remove(element: self)
  }
  
  func flag(_ reason: String) {
    hide()
    Task.detached {
      do {
        try await api.flag(input:.init(chat: .some(self.id), reason: reason))
      } catch let err {
        Monitoring.error(err)
        print(err)
      }
    }
  }
}

extension Gql.AttachmentInput {
  var attachment: Gql.FMessage.Attachment {
    var dict: [String: AnyHashable] = [
      "type": type,
      "url": url,
      "id" : id
    ]
    if let mime = mime.unwrapped {
      dict["mime"] = mime
    }
    if let data = data.unwrapped {
      dict["data"] = data
    }
    if let latitude = latitude.unwrapped, let longitude = longitude.unwrapped {
      dict["latitude"] = latitude
      dict["longitude"] = longitude
    }
    if let address = address.unwrapped {
      dict["address"] = address
    }
    if let width = width.unwrapped, let height = height.unwrapped {
      dict["width"] = width
      dict["height"] = height
    }
    if let duration = duration.unwrapped {
      dict["duration"] = duration
    }
    return .init(_dataDict: DataDict(data: dict, fulfilledFragments: Set()))
  }
}
