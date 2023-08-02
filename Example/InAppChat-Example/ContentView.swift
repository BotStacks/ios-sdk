//
//  ContentView.swift
//  InAppChat-Example
//
//  Created by Zaid Daghestani on 1/24/23.
//

import InAppChat
import SwiftUI


enum Routes: Equatable {
  case Splash
  case Login
  case Chat
}

struct ContentView: View {
  
  public init() {}

  var body: some View {
    InAppChatUI {
      IACMainRoutes(initialPath: "/splash") {
        Route("splash") {
          Splash()
        }
        Route("login") {
          Login()
        }
      }
    }
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
