//
//  UserSharedMedia.swift
//  BotStacksChat
//
//  Created by Zaid Daghestani on 2/1/23.
//

import Foundation

public class UserSharedMedia: Pager<Message> {
  let id: String

  public init(_ id: String) {
    self.id = id
    super.init()
  }

  override public func load(skip: Int, limit: Int) async -> [Message] {
    do {
      return try await api.getSharedMedia(user: id)
    } catch let err {
      Monitoring.error(err)
    }
    return items
  }
}
