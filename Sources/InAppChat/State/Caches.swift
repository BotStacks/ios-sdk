//
//  File.swift
//
//
//  Created by Zaid Daghestani on 2/28/23.
//

import Foundation

class Caches: ObservableObject {
  @Published var user: [String: User] = [:]
  @Published var messages: [String: Message] = [:]
  @Published var chats: [String: Chat] = [:]
  @Published var chatsByUID: [String: Chat] = [:]
  var chatFetches = Set<String>()
}
