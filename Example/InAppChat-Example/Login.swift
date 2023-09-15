//
//  LoginScreen.swift
//  G2Minus
//
//  Created by Zaid Daghestani on 1/28/23.
//

import Foundation
import InAppChat
import SwiftUI
import UserNotifications
import WebKit


struct Login: View {

  @Environment(\.openURL) private var openURL
  @Environment(\.geometry) private var geometry
  @Environment(\.iacTheme) private var theme
  @EnvironmentObject var navigator: Navigator
    @ObservedObject var app = InAppChat.shared
    @State var loggingIn = false

  let isEth = InAppChat.shared.tenant.loginType != "email"
  @State var terms = false
  @State var email = ""
  @State var password = ""
  @FocusState var passwordFocus
  
  @State var didError = false
  @State var message = ""
  
  func login() {
    if !loggingIn {
      if email.isEmpty || !email.isEmail() {
        message = "Please enter a valid email."
        didError = true
      } else if password.isEmpty || password.count < 4 {
        message = "Please enter a valid password"
        didError = true
      } else {
        if loggingIn {
          return
        }
        loggingIn = true
        Task {
          do {
            let res = try await InAppChat.shared.basicLogin(
              email: email,
              password: password
            )
            print("Finish login")
            if res {
              await MainActor.run {
                self.navigator.navigate("/chats")
                let center = UNUserNotificationCenter.current()
                center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
                  DispatchQueue.main.async {
                    UIApplication.shared.registerForRemoteNotifications()
                  }
                }
              }
            } else {
              await MainActor.run {
                message = "Invalid credentials. Please try again"
                didError = true
              }
            }
          } catch let err {
            print("error logging in ", err)
          }
          print("Calling callback")
          await MainActor.run {
            self.loggingIn = false
          }
        }
      }
    }
  }
  

  var body: some View {
    Splash {
      VStack {
          Spacer()
          if loggingIn {
            Spinner().size(60.0)
          }
        HStack {
          TextField("Email", text: $email)
            .keyboardType(.emailAddress)
            .textContentType(.emailAddress)
            .autocapitalization(.none)
            .submitLabel(.next)
            .foregroundColor(theme.colors.text)
            .onSubmit {
              passwordFocus = true
            }
            .grow()
        }
        .padding(.horizontal, 16)
        .background(Color.white)
        .cornerRadius(8)
        .height(44)
        .padding(.horizontal, 32)
        HStack {
          SecureField("Password", text: $password)
            .focused($passwordFocus)
            .textContentType(.password)
            .submitLabel(.done)
            .foregroundColor(theme.colors.text)
            .onSubmit({
              login()
            })
            .grow()
        }
        .padding(.horizontal, 16)
        .background(Color.white)
        .cornerRadius(8)
        .height(44)
        .padding(.horizontal, 32)
        
        Button {
          navigator.navigate("/register")
        } label: {
          HStack {
            Text("Don't have an account?")
              .foregroundColor(.white)
            Text("Sign up")
              .foregroundColor(.blue)
              .underline()
          }
        }
        Button {
          login()
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
        Button {
          terms = true
        } label: {
          HStack {
            Text("By logging in you agree to the")
              .foregroundColor(.white)
            Text("Terms of Service")
              .foregroundColor(.blue)
              .underline()
          }
        }
      }.padding(.bottom, geometry.insets.bottom)
        .sheet(isPresented: $terms) {
          ZStack(alignment: .topTrailing) {
            SwiftUIWebView(url: .init(string: "https://inappchat.io/terms-of-services")!)
              .grow()
            Button {
              terms = false
            } label: {
              Image(systemName: "xmark")
            }.size(44.0)
          }
        }
    }.alert(
      "Login Failed",
      isPresented: $didError,
      presenting: message
    ) { details in
      Button("Ok") {
        // Handle the retry action.
        didError = false
      }
    } message: { details in
      Text(details)
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


struct SwiftUIWebView: UIViewRepresentable {
  typealias UIViewType = WKWebView
  
  let webView: WKWebView
  
  init(url: URL) {
    webView = WKWebView(frame: .zero)
    webView.load(.init(url: url))
  }
  
  func makeUIView(context: Context) -> WKWebView {
    webView
  }
  func updateUIView(_ uiView: WKWebView, context: Context) {
  }
}
