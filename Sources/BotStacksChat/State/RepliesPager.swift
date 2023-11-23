//
//  RepliesPager.swift
//  BotStacksChat
//
//  Created by Zaid Daghestani on 2/16/23.
//

import Foundation
import SwiftUI

public class RepliesPager: Pager<Message> {

  let message: Message

  public init(_ message: Message) {
    self.message = message
    super.init()
    RepliesPager.pagers[message.id] = self
  }

  static var pagers: [String: RepliesPager] = [:]

  func setReplies(_ messages: [Message]) {
    self.items = messages
    self.hasMore = false
  }

  override public func load(skip: Int, limit: Int) async throws -> [Message] {
    return try await api.getReplies(for: message.id, skip: skip, limit: limit)
  }

}
