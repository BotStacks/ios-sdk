//
//  Member.swift
//  InAppChat
//
//  Created by Zaid Daghestani on 6/28/23.
//

import Foundation

public final class Member: ObservableObject, Identifiable {

  public let chat_id: String
  public let user_id: String
  public let created_at: Date
  @Published public var role: Gql.MemberRole

  var user: User {
    return User.get(user_id)
  }

  var chat: Chat {
    return Chat.get(chat_id)
  }

  init(chat_id: String, user_id: String, created_at: Date, role: Gql.MemberRole) {
    self.id = id
    self.chat_id = chat_id
    self.user_id = user_id
    self.role = role
    self.created_at = created_at
  }

  static func fromGql(_ members: [Gql.FMember]) -> [Member] {
    return members.map {
      let _ = User.get($0.user)
      return Member(chat_id: $0.chat_id, user_id: $0.user.id, created_at: $0.created_at.toDate()!.date, role: $0.role)
    }
  }

  var isMember: Bool {
    switch self.role {
    case .admin:
    case .member:
    case .owner:
      return true
    default:
      return false
    }
  }

}
