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
          text: text,
          to: self.id,
          inReplyTo: inReplyTo?.id
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

  func send(attachment: Gql.AttachmentInput, inReplyTo: Message?) {
    let m = Message.init(
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
    self.sending.insert(m, at: 0)
    Task.detached {
      do {
        let newMessage = try await api.send(
          attachment: attachment,
          to: self.id,
          inReplyTo: inReplyTo?.id
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

  func send(file: File, type: Gql.AttachmentType, inReplyTo: Message?) {
    Task.detached {
      let url = try await api.uploadFile(file: file)
      DispatchQueue.main.async {
        self.send(attachment: .init(id: UUID().uuidString, type: .case(type), url: url), inReplyTo: inReplyTo)
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

}

extension Gql.AttachmentInput {
  var attachment: Gql.FMessage.Attachment {
    var dict: [String: AnyHashable] = [
      "type": type.rawValue,
      "url": url
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
