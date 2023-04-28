import Foundation

extension Thread {
  public static func gen(
    user: User? = nil,
    group: Group? = nil,
    latest: Message? = nil,
    items: [Message]? = nil,
    unreadCount: Int? = nil
  ) -> Thread {
    let id = UUID().uuidString
    var _user = user
    var _group = group
    if user == nil && group == nil {
      if faker.number.randomBool() {
        _group = Group.gen()
      } else {
        _user = User.sample
      }
    }
    let users =
      _user != nil
    ? [User.sampleCurrent, _user!] : _group!.participants.map(\.user)
    let _items =
      items
      ?? (chance(8, outOf: 10)
      ? (0...faker.number.randomInt(min: 1, max: 200)).map({ _ in
        return Message.gen(user: users.randomElement()!)
      }) : []).sorted(by: { a, b in
        return a.createdAt.timeIntervalSince1970 > b.createdAt.timeIntervalSince1970
      })
    let _latest = latest ?? (!_items.isEmpty ? _items[0] : nil)
    let _unreadCount =
    _items.first?.user
        .isCurrent == true || _items.isEmpty
      ? 0
      : _items.firstIndex(where: { message in
        message.user.isCurrent == true
      }).map({ $0 + 1 }) ?? faker.number.randomInt(min: 0, max: _items.count)
    let t = Thread(
      id: id, user: _user, group: _group, latest: _latest,
      items: _items, unreadCount: _unreadCount)
    return t
  }

  func genThreadIDForMessageThread() -> String {
    let group = Group.random()
    let thread = Thread.get(group: group.id) ?? Thread.gen(group: group)
    return thread.id
  }
}
