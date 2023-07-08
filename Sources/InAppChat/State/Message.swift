import Foundation
import SwiftDate
import SwiftyJSON

public final class Message: ObservableObject, Identifiable {

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
  public let chatID: String

  public var text: String? {
    didSet {
      makeMarkdown()
    }
  }
  @Published public var markdownText: String = ""

  func makeMarkdown() {
    if let text = text {
      markdownText = mentionsToMarkdown(linkPhoneToMarkdown(text))
    }
  }
  
  var chat: Chat {
    return Chat.get(chatID)!
  }
  
  @Published public var attachments: [Gql.FMessage.Attachment]?
  @Published public var reactions: Reactions?
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
    chatID: String,
    parent: Message? = nil,
    text: String = "",
    attachments: [Gql.FMessage.Attachment]? = nil,
    reactions: Reactions,
    replyCount: Int = 0,
    status: Status? = nil,
    favorite: Bool = false,
    currentReaction: String? = nil
  ) {
    self.id = id
    self.createdAt = createdAt
    self.userID = userID
    self.chatID = chatID
    self.parent = parent
    self.text = text
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

  public init(_ msg: Gql.FMessage) {
    self.id = msg.id
    self.createdAt = msg.created_at
    self.chatID = msg.chat_id
    self.parentID = msg.parent_id
    self.userID = msg.user.id
    self.text = msg.text ?? ""
    self.attachments = msg.attachments
    self.reactions = parseReactions(reactions: msg.reactions)
    self.currentReaction = self.reactions?.first(where: {$0.uids.contains(User.current!.id)})?.reaction
    self.update(msg)
    self.makeMarkdown()
    Chats.current.cache.messages[id] = self
    fillChat()
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
  
  func fillChat() {
    if chat == nil {
      print("Message Fill Chat")
      Chat.fetch(id: chatID)
    }
  }

  var user: User {
    return User.get(userID)!
  }

  func update(_ msg: Gql.FMessage) {
    self.replyCount = msg.reply_count
    self.attachments = msg.attachments
    self.text = msg.text
    self.reactions = parseReactions(reactions: msg.reactions)
    self.currentReaction = self.reactions?.first(where: {$0.uids.contains(User.current!.id)})?.reaction
//    if let replies = msg.replies?.map(Message.get) {
//      self.replies.setReplies(replies)
//    }
  }

  var msg: String {
    if let att = attachments?.first {
      switch att.type {
      case .image:
        return "[Image] \(att.url)"
      case .video:
        return "[Video] \(att.url)"
      case .audio:
        return "[Audio] \(att.url)"
      case .file:
        return "[File] \(att.url)"
      case .location:
        return "[Location] \(att.loc?.display ?? "")"
      case .vcard:
        return "[Contact] \(att.contact?.displayName ?? "")"
      default:
        print("unknown attachment type \(att.type)")
      }
    }
    return text ?? ""
  }

  var summary: String {
    return "\(user.username): \(msg)"
  }

  var reacting = false
  var favoriting = false
  var editingText = false

  static func get(_ id: String) -> Message? {
    return Chats.current.cache.messages[id]
  }

  static func get(_ msg: Gql.FMessage) -> Message {
    if let m = get(msg.id) {
      m.update(msg)
      return m
    }
    return Message(msg)
  }
}

struct Loc {
  
  let latitude: Double?
  let longitude: Double?
  let address: String?
  let link: String
  let markdownLink: String
  let display: String
  
  init(latitude: Double?, longitude: Double?, address: String?) {
    self.latitude = latitude
    self.longitude = longitude
    self.address = address
    if let address = address {
      self.link = "https://maps.apple.com/?q=\(address.urlEncoded)"
      self.display = address
    } else if let lat = latitude, let lng = longitude {
      self.link = "https://maps.apple.com/?ll=\(lat),\(lng)"
      self.display = "\(lat),\(lng)"
    } else {
      self.link = ""
      self.display = ""
    }
    self.markdownLink = "[Location\(address.map({": \($0)"}) ?? "")](\(link))"
  }
}

extension Gql.FMessage.Attachment {
  var loc: Loc? {
    if self.type == .location {
      return Loc(latitude: self.latitude, longitude: self.longitude, address: self.address)
    }
    return nil
  }
}
