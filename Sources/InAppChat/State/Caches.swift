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
  @Published var groups: [String: Group] = [:]
  @Published var threads: [String: Thread] = [:]
  @Published var threadsByUID: [String: Thread] = [:]
  @Published var threadsByGroup: [String: Thread] = [:]
  var threadFetches = Set<String>()
}
