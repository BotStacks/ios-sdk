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

  init(@ViewBuilder _ content: @escaping () -> Content) {
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
      ZStack {
        VStack {
            Image("inappchat-icon").size(120.0)
            Image("inappchat-text").frame(width: 150.0)
          
          Text("Elegant, ")
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
    .onChange(of: !app.loaded) { newValue in
      if newValue {
          navigator.navigate(app.isUserLoggedIn ? "/chats" : "/login", replace: true)
      }
    }
  }
}

extension Splash where Content == EmptyView {
  init() {
    self.content = nil
  }
}

struct Splash_Previews: PreviewProvider {
  static var previews: some View {
    Splash()
  }
}
