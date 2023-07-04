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
    return User.get(user_id)!
  }

  var chat: Chat {
    return Chat.get(chat_id)!
  }

  init(chat_id: String, user_id: String, created_at: Date, role: Gql.MemberRole) {
    self.id = id
    self.chat_id = chat_id
    self.user_id = user_id
    self.role = role
    self.created_at = created_at
  }
  
  static func fromGql(_ member: Gql.FMember) -> Member {
    let _ = User.get(member.user)
    return Member(chat_id: member.chat_id, user_id: member.user.id, created_at: member.created_at.toDate()!.date, role: member.role)
  }

  static func fromGql(_ members: [Gql.FMember]) -> [Member] {
    return members.map(Member.fromGql)
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
