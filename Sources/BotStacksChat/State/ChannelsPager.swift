//
//  NetworkPager.swift
//  BotStacksChat
//
//  Created by Zaid Daghestani on 2/6/23.
//

import Foundation

public class ChannelsPager: Pager<Chat> {

  override public func load(skip: Int, limit: Int) async throws -> [Chat] {
    return try await api.getGroups(skip: skip, limit: limit)
  }
}
