import Contacts
import Photos
import PhotosUI

extension Thread {

  func send(_ text: String, inReplyTo: Message?) {
    let m = Message.init(
      id: UUID().uuidString,
      createdAt: Date(),
      userID: User.current!.id,
      threadID: self.id,
      parent: inReplyTo,
      text: text,
      reactions: [],
      status: .sending
    )
    self.sending.insert(m, at: 0)
    Task.detached {
      do {
        let newMessage = try await api.send(
          text: text,
          to: self,
          inReplyTo: inReplyTo
        )
        publish {
          self.sending.remove(element: m)
          self.items.insert(newMessage, at: 0)
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

  func send(attachment: Message.Attachment, inReplyTo: Message?) {
    let m = Message.init(
      id: UUID().uuidString,
      createdAt: Date(),
      userID: User.current!.id,
      threadID: self.id,
      parent: inReplyTo,
      text: "",
      attachments: [attachment],
      reactions: [],
      status: .sending
    )
    self.sending.insert(m, at: 0)
    Task.detached {
      do {
        let newMessage = try await api.send(
          attachment: attachment,
          to: self,
          inReplyTo: inReplyTo
        )
        publish {
          self.sending.remove(element: m)
          self.items.insert(newMessage, at: 0)
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

  func send(file: URL, inReplyTo: Message?) {

  }

  func sendLocation(inReplyTo: Message?) {
    Task.detached {
      do {
        let location = try await LocationUtil.fetch()
        let m = Message.init(
          id: UUID().uuidString,
          createdAt: Date(),
          userID: User.current!.id,
          threadID: self.id,
          parent: inReplyTo,
          text: "",
          location: .init(longitude: location.longitude, latitude: location.latitude),
          reactions: [],
          status: .sending
        )
        publish {
          self.sending.insert(m, at: 0)
        }
        let newMessage = try await api.send(
          location: .init(
            longitude: location.longitude,
            latitude: location.latitude
          ),
          to: self,
          inReplyTo: inReplyTo
        )
        publish {
          self.sending.remove(element: m)
          self.items.insert(newMessage, at: 0)
        }
      } catch let err {
        print("Location", err)
      }

    }
  }

  func send(contact: CNContact, inReplyTo: Message?) {
    let _contact = contact.toAppContact()
    let m = Message.init(
      id: UUID().uuidString,
      createdAt: Date(),
      userID: User.current!.id,
      threadID: self.id,
      parent: inReplyTo,
      text: "",
      contact: _contact,
      reactions: [],
      status: .sending
    )
    self.sending.insert(m, at: 0)
    Task.detached {
      do {
        let newMessage = try await api.send(
          contact: _contact,
          to: self,
          inReplyTo: inReplyTo
        )
        publish {
          self.sending.remove(element: m)
          self.items.insert(newMessage, at: 0)
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

}
