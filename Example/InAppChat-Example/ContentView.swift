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
  
  @StateObject var pilot = UIPilot(initial: Routes.Splash)

  public init() {}

  var body: some View {
    UIPilotHost(pilot) { route in
      switch (route) {
        case .Splash: Splash()
        case .Login: Login()
        case .Chat: InAppChatUI()
      }
    }.edgesIgnoringSafeArea(.all)
      .uipNavigationBarHidden(true)
      .navigationBarBackButtonHidden()
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
