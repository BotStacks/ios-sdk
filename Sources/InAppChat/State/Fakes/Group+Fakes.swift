import Foundation
import SwiftDate

extension Group {

  public static func random() -> Group {
    if faker.number.randomBool() {
      return Chats.current.cache.groups.randomElement()?.value ?? gen()
    }
    return gen()
  }

  public static func gen(
    name: String? = nil,
    avatar: String? = nil,
    desc: String? = nil,
    users: [User]? = nil,
    admins: [String]? = nil,
    _private: Bool? = nil,
    invites: [User]? = nil
  ) -> Group {
    let _name = name ?? faker.internet.username()
    let _avatar = avatar ?? (chance(5, outOf: 10) ? nil : randomImage())
    let _desc =
      desc ?? faker.lorem.paragraph(sentencesAmount: faker.number.randomInt(min: 1, max: 4))
    var _admins = admins ?? []
    var _users =
      users
      ?? (0..<faker.number.randomInt(min: 3, max: 20)).map({ int in
        let u = User.sample
        if admins == nil && faker.number.randomBool() {
          _admins.append(u.id)
        }
        return u
      })
    var _invites: [User] = invites ?? []
    if faker.number.randomBool() {
      _users.append(User.sampleCurrent)
      if faker.number.randomBool() {
        _admins.append(User.current!.id)
      }
    } else if invites == nil {
      _invites = randomAmount(from: _users)
    }
    return Group(
      id: UUID().uuidString,
      name: _name,
      description: _desc,
      image: _avatar,
      participants: _users.map({
        Participant(
          appUserId: $0.email, eRTCUserId: $0.id, role: faker.number.randomBool() ? .admin : .user,
          joinedAtDate: faker.date.between(Date() - 30.days, Date()))
      }),
      _private: _private ?? faker.number.randomBool(),
      invites: _invites
    )
  }
}
