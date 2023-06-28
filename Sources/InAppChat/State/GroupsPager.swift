//
//  GroupsPager.swift
//  InAppChat
//
//  Created by Zaid Daghestani on 2/6/23.
//

import Foundation

public class GroupsPager: Pager<Chat> {

  override public func load(skip: Int, limit: Int) async throws -> [Chat] {
    return try await api.getJoinedGroupThreads(skip: skip, limit: limit)
  }
}
