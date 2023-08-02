//
//  LoginScreen.swift
//  G2Minus
//
//  Created by Zaid Daghestani on 1/28/23.
//

import Auth0
import Foundation
import InAppChat
import SwiftUI
import JWTDecode
import UserNotifications


struct Login: View {

  @Environment(\.openURL) private var openURL
  @Environment(\.geometry) private var geometry
  @EnvironmentObject var navigator: Navigator
    @ObservedObject var app = InAppChat.shared
    @State var loggingIn = false

  let isEth = InAppChat.shared.tenant.loginType != "email"

  var body: some View {
    Splash {
      VStack {
          Spacer()
          if loggingIn {
            Spinner().size(60.0)
          }
          Button {
              print("Start Auth0")
            Auth0
              .webAuth()
              .start { result in
                switch result {
                case .success(let credentials):
                  print("Obtained credentials: \(credentials)")
                  login(credentials: credentials) {
                      if (InAppChat.shared.isUserLoggedIn) {
                          UNUserNotificationCenter.current()
                              //2
                              .requestAuthorization(options: [.alert, .sound, .badge]) { granted, _ in
                                //3
                                print("Permission granted: \(granted)")
                                  DispatchQueue.main.async {
                                      UIApplication.shared.registerForRemoteNotifications()
                                  }
                              }
                        navigator.navigate("/chats", replaceAll: true)
                      }
                  }
                case .failure(let error):
                  print("Failed with: \(error)")
                }
              }
          } label: {
              HStack {
                HStack {
                  Text("Login")
                        .foregroundColor(Color.white)
                    .textCase(.uppercase)
                    .font(.title2)
                }
                .padding(.all, 16.0)
                .frame(maxWidth: .infinity)
                .background(Color(hex: loggingIn ? 0x165a72 : 0x2596be))
                .cornerRadius(32.0)
                
              }.frame(maxWidth: .infinity)
              .padding(.horizontal, 32.0)
              .padding(.vertical, 16.0)
          }.disabled(loggingIn)
      }.padding(.bottom, geometry.insets.bottom)
    }
  }

    func login(credentials: Credentials, _ cb: @escaping () -> Void) {
    if loggingIn {
      return
    }
    loggingIn = true
    Task {
      do {
          guard let jwt = try? decode(jwt: credentials.idToken),
                let id = jwt["sub"].string else { return }
          let name = jwt["name"].string
          let nickname = jwt["nickname"].string ?? "0x41112A2e8626330752A8f9353462edd4771a48a2"
          let picture = "https://api.poisonpog.org/ipfs/31.png"
          let _ = try await InAppChat.shared.login(
            accessToken: nil,
            userId: id,
            username: nickname, picture: picture,
            displayName: name
          )
        print("Finish login")
      } catch let err {
        print("error logging in ", err)
      }
      print("Calling callback")
      await MainActor.run {
        self.loggingIn = false
        cb()
      }
    }
  }
}

struct Login_Previews: PreviewProvider {
  static var previews: some View {
    Login()
  }
}

let __firstpart = "[A-Z0-9a-z]([A-Z0-9a-z._%+-]{0,30}[A-Z0-9a-z])?"
let __serverpart = "([A-Z0-9a-z]([A-Z0-9a-z-]{0,30}[A-Z0-9a-z])?\\.){1,5}"
let __emailRegex = __firstpart + "@" + __serverpart + "[A-Za-z]{2,8}"
let __emailPredicate = NSPredicate(format: "SELF MATCHES %@", __emailRegex)

extension String {
  func isEmail() -> Bool {
    return __emailPredicate.evaluate(with: self)
  }
}
