//
//  GroupsPager.swift
//  InAppChat
//
//  Created by Zaid Daghestani on 2/6/23.
//

import Foundation

public class GroupsPager: Pager<Thread> {

  override public func load(skip: Int, limit: Int) async throws -> [Thread] {
    return try await api.getJoinedGroupThreads(skip: skip, limit: limit)
  }
}
