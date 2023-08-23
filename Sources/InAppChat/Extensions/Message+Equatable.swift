//
//  Message+Equatable.swift
//  InAppChat
//
//  Created by Zaid Daghestani on 1/31/23.
//

import Foundation

extension Message : Equatable {
  public static func ==(lhs: Message, rhs: Message) -> Bool {
    return lhs.id == rhs.id
  }
}
