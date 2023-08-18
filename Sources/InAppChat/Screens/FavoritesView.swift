//
//  Favorites.swift
//  InAppChat
//
//  Created by Zaid Daghestani on 2/1/23.
//

import Foundation
import SwiftUI

public class UIFavoritesController: UIBaseController {
  
  public override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "messages" {
      let list = segue.destination as! UIMessageList
      list.onPress = {
        message in
        self.performSegue(withIdentifier: "chat", sender: message.chat)
      }
    }
  }
}



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
