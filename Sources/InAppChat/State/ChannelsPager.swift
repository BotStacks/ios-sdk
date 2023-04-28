//
//  NetworkPager.swift
//  InAppChat
//
//  Created by Zaid Daghestani on 2/6/23.
//

import Foundation

public class ChannelsPager: Pager<Group> {

  override public func load(skip: Int, limit: Int) async throws -> [Group] {
    return try await api.getGroups(skip: skip, limit: limit)
  }
}
