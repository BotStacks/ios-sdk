//
//  Splash.swift
//  G2Minus
//
//  Created by Zaid Daghestani on 1/28/23.
//

import ActivityIndicatorView
import Foundation
import InAppChat
import SwiftUI


struct Splash<Content>: View where Content: View {

  @Environment(\.geometry) var geometry
  let content: (() -> Content)?
  @EnvironmentObject var navigator: Navigator

  @ObservedObject var app = InAppChat.shared
  let mini: Bool
  init(mini: Bool = false, @ViewBuilder _ content: @escaping () -> Content) {
    self.mini = mini
    self.content = content
  }

  var body: some View {
    ZStack(alignment: .top) {
      LinearGradient(
        colors: [Color("BGTop"), Color("BGBottom")], startPoint: .top, endPoint: .bottom
      )
      .edgesIgnoringSafeArea(.all)
      Image("SplashWeb")
        .resizable()
        .aspectRatio(contentMode: .fit)
      if mini {
        VStack {
          VStack {
            HStack {
              Image("inappchat-icon")
                .resizable().aspectRatio(contentMode: .fit).size(50.0)
              Image("inappchat-text").resizable().frame(width: 225.0, height: 28.0)
                .tint(Color.white)
                .foregroundColor(Color.white)
            }
            if !app.loaded {
              Spinner().size(60.0)
            }
          }.padding(.bottom, 60.0)
            .padding(.top, geometry.insets.top + 20.0)
          if let content = content {
            content()
          }
        }.grow()
      } else {
        ZStack {
          VStack {
            Image("inappchat-icon")
              .resizable().aspectRatio(contentMode: .fit).size(130.0)
            Image("inappchat-text").resizable().frame(width: 225.0, height: 28.0)
              .tint(Color.white)
              .foregroundColor(Color.white)
            
            Text("Simple and elegant chat services")
              .multilineTextAlignment(.center)
              .foregroundColor(.white)
            if !app.loaded {
              Spinner().size(60.0)
            }
          }.padding(.bottom, !app.loaded ? 0.0 : 60.0)
        }.grow()
        if let content = content {
          content()
        }
      }
      
    }
    .onChange(of: app.loaded) { newValue in
      if newValue {
        navigator.navigate(app.isUserLoggedIn ? "/chats" : "/login", replace: true)
          if (app.isUserLoggedIn) {
            let center = UNUserNotificationCenter.current()
            center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
              
              if let error = error {
                // Handle the error here.
              }
              DispatchQueue.main.async {
                UIApplication.shared.registerForRemoteNotifications()
              }
              // Enable or disable features based on the authorization.
            }
          }
      }
    }.preferredColorScheme(.dark)
  }
}

extension Splash where Content == EmptyView {
  init() {
    self.mini = false
    self.content = nil
  }
}

struct Splash_Previews: PreviewProvider {
  static var previews: some View {
    Splash()
  }
}
