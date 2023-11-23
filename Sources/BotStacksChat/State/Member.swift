//
//  Member.swift
//  BotStacksChat
//
//  Created by Zaid Daghestani on 6/28/23.
//

import Foundation

public typealias MemberRole = Gql.MemberRole

public final class Member: ObservableObject {

   let chat_id: String
   let user_id: String
   let created_at: Date
  @Published  var role: Gql.MemberRole

  var user: User {
    return User.get(user_id)!
  }

  var chat: Chat {
    return Chat.get(chat_id)!
  }

  init(chat_id: String, user_id: String, created_at: Date, role: Gql.MemberRole) {
    self.chat_id = chat_id
    self.user_id = user_id
    self.role = role
    self.created_at = created_at
  }

  
  static func fromGql(_ member: Gql.FMember) -> Member {
    let _ = User.get(.init(_dataDict: member.user.__data))
    return Member(chat_id: member.chat_id, user_id: member.user.id, created_at: member.created_at, role: member.role.value!)
  }

  static func fromGql(_ members: [Gql.FMember]) -> [Member] {
    return members.map(Member.fromGql)
  }

  var isMember: Bool {
    switch self.role {
    case .admin:
      fallthrough
    case .member:
      fallthrough
    case .owner:
      return true
    default:
      return false
    }
  }
  
  var isAdmin: Bool {
    switch self.role {
    case .admin:
      return true
    case .owner:
      return true
    default:
      return false
    }
  }
}

extension Member: Equatable {
   public static func == (lhs: Member, rhs: Member) -> Bool {
    return lhs.user_id == rhs.user_id && lhs.chat_id == rhs.chat_id
  }
}
