//
//  ThreadsPager.swift
//  InAppChat
//
//  Created by Zaid Daghestani on 2/6/23.
//

import Foundation

public class ThreadsPager: Pager<Message> {

  public override func load(skip: Int, limit: Int) async throws -> [Message] {
    let messages = try await api.getReplyThreads(skip: skip, limit: limit)
    return try await messages.concurrentMap { message in
      if message.chat == nil {
        let _ = try await api.get(chat: message.chatID)
      }
      return message
    }
  }
}
