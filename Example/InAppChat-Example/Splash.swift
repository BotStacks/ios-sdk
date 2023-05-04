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
          Image("g2minus")
          Text("End-to-end encrypted messenger\nbuilt on ethereum")
            .multilineTextAlignment(.center)
            .foregroundColor(.white)
          if app.loading {
            Spinner().size(60.0)
          }
        }.padding(.bottom, app.loading ? 0.0 : 60.0)
      }.grow()
      if let content = content {
        content()
      }
    }
    .onChange(of: app.loading) { newValue in
      if !newValue {
        navigator.navigate(app.loggedIn ? "/chats" : "/login", replace: true)
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
