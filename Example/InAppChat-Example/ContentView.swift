//
//  ContentView.swift
//  InAppChat-Example
//
//  Created by Zaid Daghestani on 1/24/23.
//

import InAppChat
import SwiftUI

struct ContentView: View {

  init() {
    _ = User.sampleCurrent
  }

  var body: some View {
    InAppChatUI()
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
