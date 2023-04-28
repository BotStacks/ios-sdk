//
//  Favorites.swift
//  InAppChat
//
//  Created by Zaid Daghestani on 2/1/23.
//

import Foundation

public class Favorites: Pager<Message> {

  public override init() {
    super.init()
    if preview {
      self.items = random(count: 20, item: { Message.gen(favorite: true) })
    }
  }

  public override func load(skip: Int, limit: Int) async -> [Message] {
    do {
      return try await api.favorites(skip: skip, limit: limit)
    } catch let err {
      Monitoring.error(err)
    }
    return []
  }

}
