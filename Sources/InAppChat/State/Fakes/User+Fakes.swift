import Foundation
import SwiftDate

extension User {
  public static var sample: User {
    let user = User(
      id: UUID().uuidString,
      email: faker.internet.email(),
      username: faker.internet.username(),
      displayName: faker.name.name(),
      avatar: randomImage(),
      lastSeen: faker.date.between(Date.now - 45.days, Date.now),
      status: allStatus.randomElement()!
    )
    return user
  }

  public static var sampleCurrent: User {
    if current == nil {
      current = sample
    }
    return current!
  }

  public static func gen() -> User {
    return sample
  }
}

let allStatus: [AvailabilityStatus] = [.online, .away, .dnd, .invisible, .offline]
