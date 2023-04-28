//
//  Favorites.swift
//  InAppChat
//
//  Created by Zaid Daghestani on 2/1/23.
//

import Foundation
import SwiftUI

public struct FavoritesView: View {

  let favorites = Chats.current.favorites
  @Environment(\.geometry) var geometry

  public init() {
  }

  public var body: some View {
    ScrollView {
      Header(title: "Favorite Messages", showSearch: true)
      PagerList(pager: favorites, divider: true) {
        message in
        MessageView(message: message)
      }.height(geometry.safeHeight.minusHeader)
    }.edgesIgnoringSafeArea(.all)
  }
}
