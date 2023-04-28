import Foundation
import SwiftDate

extension Message {
  public static var sample: Message {
    return gen()
  }

  public static var sampleImage: Message {
    return gen(attachments: [Attachment(url: randomImage(), kind: .image)])
  }

  public static var sampleGif: Message {
    return gen(attachments: [
      Attachment(url: "https://media.giphy.com/media/aDfCgikNaT7FECc65x/giphy.gif", kind: .image)
    ])
  }

  public static func gen(
    user: User = User.sample,
    threadID: String? = nil,
    text: String? = nil,
    parent: Message? = nil,
    attachments: [Attachment]? = nil,
    location: Location? = nil,
    contact: Contact? = nil,
    replies: Int = 2,
    reactions: [Reaction]? = nil,
    createdAt: Date = Date(),
    favorite: Bool? = nil,
    currentReaction: String? = nil
  ) -> Message {
    let statuses: [Status?] = [nil, Status.delivered, Status.seen]
    let _reactions = reactions ?? randomReactions()
    return Message(
      id: UUID().uuidString,
      createdAt: faker.date.between(Date.now - 45.days, Date.now),
      userID: user.id,
      threadID: threadID ?? UUID().uuidString,
      parent: parent,
      text: text ?? faker.lorem.paragraph(sentencesAmount: faker.number.randomInt(min: 1, max: 4)),
      attachments: attachments
        ?? (0..<faker.number.randomInt(min: 0, max: 5)).map({ _ in Message.Attachment.gen() }),
      location: location,
      contact: contact,
      reactions: _reactions,
      replyCount: replies,
      status: user.isCurrent ? statuses.randomElement() as? Status : nil,
      favorite: favorite ?? faker.number.randomBool(),
      currentReaction: currentReaction
        ?? (chance(1, outOf: 3) ? _reactions.randomElement()?.emojiCode : nil)
    )
  }
}

func randomReactions() -> [Reaction] {
  var fakeReactions = ["🤖", "👽", "🦄", "😁", "😅", "😉", "🤠", "👾", "🙌", "👨‍🚀"]
  return random(count: 3) {
    let emoji = fakeReactions.randomElement()!
    fakeReactions.remove(element: emoji)
    let count = faker.number.randomInt(min: 1, max: 20)
    return Reaction(emojiCode: emoji, count: count, users: (0..<count).map({it in User.gen().id}))
  }
}
