//
//  User.swift
//  InAppChat
//
//  Created by Zaid Daghestani on 2/6/23.
//

import Foundation

extension Array where Element == User {
  var usernames: String {
    let uns = self[0..<Swift.min(self.count, 3)].map(\.usernameFb)
    if count < 3 {
      return uns.join(" and ")
    } else if count == 3 {
      return "\(uns[0]), \(uns[1]) and \(uns[2])"
    } else {
      return "\(uns[0]), \(uns[1]) and \(count - 3) others"
    }
  }
}
