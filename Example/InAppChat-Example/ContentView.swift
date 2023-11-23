//
//  ContentView.swift
//  InAppChat-Example
//
//  Created by Zaid Daghestani on 1/24/23.
//

import BotStacksChat
import SwiftUI


enum Routes: Equatable {
  case Splash
  case Login
  case Chat
}

struct ContentView: View {
  
  
  
  var body: some View {
    BotStacksChatUI {
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
    BotStacksChatView {
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
