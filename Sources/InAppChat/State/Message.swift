import Foundation
import SwiftDate
import SwiftyJSON

public final class Message: ObservableObject, Identifiable {

  public struct Attachment {
    public let url: String
    public let kind: Kind
    public let type: String?

    public enum Kind: String {
      case image = "image"
      case video = "video"
      case audio = "audio"
      case file = "file"
    }

    init(url: String, kind: Kind, type: String? = nil) {
      self.url = url
      self.kind = kind
      self.type = type
    }

    func toJSON() -> [String: Any] {
      return [
        "url": url,
        "kind": kind.rawValue,
        "type": type ?? "",
      ]
    }
  }

  public enum Status: String {
    case delivered = "delivered"
    case seen = "seen"
    case sent = "sent"
    case sending = "sending"
    case failed = "failed"
  }

  public let id: String
  public let createdAt: Date
  public let userID: String
  public let parentID: String?
  @Published public var parent: Message?
  public let threadID: String

  public var text: String {
    didSet {
      makeMarkdown()
    }
  }
  @Published public var markdownText: String = ""

  func makeMarkdown() {
    markdownText = mentionsToMarkdown(linkPhoneToMarkdown(text))
  }

  public var attachments: [Attachment] = []
  public var location: Location? = nil
  public var contact: Contact? = nil
  var thread: Thread? {
    return Thread.get(threadID)
  }

  @Published public var reactions: [Reaction]?
  @Published public var currentReaction: String? = nil
  @Published public var replyCount: Int = 0
  @Published public var status: Status? = nil
  @Published public var favorite: Bool = false

  lazy var replies = RepliesPager(self)

  var path: String {
    return "/message/\(id)"
  }

  public init(
    id: String,
    createdAt: Date,
    userID: String,
    threadID: String,
    parent: Message? = nil,
    text: String = "",
    attachments: [Attachment]? = nil,
    location: Location? = nil,
    contact: Contact? = nil,
    reactions: [Reaction]?,
    replyCount: Int = 0,
    status: Status? = nil,
    favorite: Bool = false,
    currentReaction: String? = nil
  ) {
    self.id = id
    self.createdAt = createdAt
    self.userID = userID
    self.threadID = threadID
    self.parent = parent
    self.text = text
    self.location = location
    self.contact = contact
    self.reactions = reactions
    self.status = status
    self.favorite = favorite
    if let attachments = attachments {
      self.attachments = attachments
    }
    self.parentID = parent?.id
    self.parent = parent
    self.currentReaction = currentReaction
    self.replies = replies
    self.makeMarkdown()
    Chats.current.cache.messages[id] = self
  }

  public init(_ msg: APIMessage) {
    self.id = msg.msgUniqueId
    self.createdAt = msg.createdAt.toDate()!.date
    self.threadID = msg.threadId
    self.parentID = msg.replyThreadFeatureData?.baseMsgUniqueId
    self.userID = msg.sendereRTCUserId
    self.location = msg.location
    self.text = msg.message ?? ""
    self.attachments = []
    self.update(msg)
    self.makeMarkdown()
    Chats.current.cache.messages[id] = self
    fillThread()
    fillParent()

  }
  func fillParent() {
    if let parentID = self.parentID {
      if let m = Message.get(parentID) {
        self.parent = m
      } else {
        Task {
          do {
            let m = try await api.get(message: parentID)
            await MainActor.run {
              self.parent = m
            }
          } catch let err {
            Monitoring.error(err)
          }
        }
      }
    }
  }
  func fillThread() {
    if thread == nil {
      Thread.fetch(id: threadID)
    }
  }

  var user: User {
    return User.get(userID) ?? User.fetched(userID)
  }

  func update(_ msg: APIMessage) {
    if let replyCount = msg.replyMsgCount {
      self.replyCount = replyCount
    }
    if let type = msg.msgType {
      switch type {
      case .image, .gif:
        self.attachments = [
          Attachment(url: msg.gify ?? (api.server + msg.media!.path!), kind: .image)
        ]
        break
      case .video:
        self.attachments = [
          Attachment(url: api.server + msg.media!.path!, kind: .video)
        ]
        break
      case .audio:
        self.attachments = [
          Attachment(url: api.server + msg.media!.path!, kind: .audio)
        ]
        break
      case .text:
        self.text = msg.message ?? ""
      default:
        break
      }
    }
    if let reactions = msg.reactions {
      self.reactions = reactions
      self.currentReaction =
        reactions.first(where: { $0.users.contains(User.current!.id) })?.emojiCode
    }
    if let favorite = msg.isStarred {
      self.favorite = favorite
    }
    if let replies = msg.replies?.map(Message.get) {
      self.replies.setReplies(replies)
    }
  }

  var msg: String {
    if let att = attachments.first {
      switch att.kind {
      case .image:
        return "[Image] \(att.url)"
      case .video:
        return "[Video] \(att.url)"
      case .audio:
        return "[Audio] \(att.url)"
      case .file:
        return "[File] \(att.url)"
      }
    } else if let location = location {
      return
        "[Location] \(location.address ?? "\(String(describing: location.latitude)), \(String(describing: location.longitude))")"
    } else if let contact = contact {
      return "[Contact] \(contact.name)"
    }
    return text
  }

  var summary: String {
    return "\(user.username ?? ""): \(msg)"
  }

  var reacting = false
  var favoriting = false
  var editingText = false

  static func get(_ id: String) -> Message? {
    return Chats.current.cache.messages[id]
  }

  static func get(_ msg: APIMessage) -> Message {
    if let m = get(msg.msgUniqueId) {
      m.update(msg)
      return m
    }
    return Message(msg)
  }
}

extension Contact {

  var markdown: String {
    return """
      \(name)
      \(numbers?.map({"[\(($0.type ?? "").isEmpty ? "" : "\($0.type!): ")\($0.number)](tel:\($0.number))"}).join("\n") ?? "")
      \(emails?.map({"[\(($0.type ?? "").isEmpty ? "" : "\($0.type!): ")\($0.email)](mailto:\($0.email))"}).join("\n") ?? "")
      """
  }

  func toJSON() -> [String: Any] {
    var ret: [String: Any] = [
      "name": name
    ]
    if let numbers = numbers {
      ret["numbers"] = numbers.map {
        $0.type != nil ? ["type": $0.type, "number": $0.number] : ["number": $0.number]
      }
    }
    if let emails = emails {
      ret["emails"] = emails.map {
        $0.type != nil ? ["type": $0.type, "email": $0.email] : ["email": $0.email]
      }
    }
    return ret
  }
}

extension Location {
  public var link: String {
    if let address = address {
      return "https://maps.apple.com/?q=\(address.urlEncoded)"
    } else if let lat = latitude, let lng = longitude {
      return "https://maps.apple.com/?ll=\(lat),\(lng)"
    }
    return ""
  }

  public var markdownLink: String {
    return "[Location\(address.map({": \($0)"}) ?? "")](\(link))"
  }

  func toJSON() -> [String: Any] {
    var j: [String: Any] = [:]
    if let address = address {
      j["address"] = address
    }
    if let lat = latitude, let lng = longitude {
      j["latitude"] = lat
      j["longitude"] = lng
    }
    return j
  }
}
