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
  
  
  
  var body: some View {
    InAppChatUI {
      Router(initialPath: "/splash") {
        Route("splash") {
          Splash()
        }
        Route("login") {
          Login()
        }
        Route("chats") {
          ChatView()
        }
        Route("register") {
          Register()
        }
      }
    }
  }
}

struct ChatView: View {
  @EnvironmentObject var navigator: Navigator
  
  var body: some View  {
    InAppChatView {
      navigator.navigate("/login")
    } onDeleteAccount: {
      
    }
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
