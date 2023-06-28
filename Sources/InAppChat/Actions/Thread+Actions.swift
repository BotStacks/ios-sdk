import Contacts
import Photos
import PhotosUI

extension Thread {

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

  func send(attachment: Gql.FMessage.Attachment, inReplyTo: Message?) {
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
        self.send(attachment: .init(_dataDict: ["type": Gql.AttachmentType.location, "latitude": location.latitude, "longitude": location.longitude, "url": "data"]), inReplyTo: inReplyTo)
      } catch let err {
        print("Location", err)
      }
    }
  }

  func send(contact: CNContact, inReplyTo: Message?) {
    self.send(attachment: .init(_dataDict: ["type": Gql.AttachmentType.vcard,"url": "data", "data": contact.toAppContact()]), inReplyTo: inReplyTo)
  }

}
