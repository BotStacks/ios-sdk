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
import WebKit




struct Register: View {
  
  enum Field {
    case name
    case email
    case password
  }
  
  @Environment(\.openURL) private var openURL
  @Environment(\.geometry) private var geometry
  @EnvironmentObject var navigator: Navigator
  @ObservedObject var app = InAppChat.shared
  @State var loggingIn = false
  
  @State var terms = false
  @State var email = ""
  @State var password = ""
  @State var displayName = ""
  @State var localImage: URL? = nil
  @State var image: URL? = nil
  @FocusState var focus: Field?
  
  @State var didError = false
  @State var message = ""
  
  @State var pickImage = false
  
  func register() {
    if !loggingIn {
      if displayName.isEmpty || displayName.count < 5 {
        message = "Username must be 5 or more characters"
        didError = true
      } else if email.isEmpty || !email.isEmail() {
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
            let res = try await InAppChat.shared.register(
              email: email,
              password: password,
              username: displayName,
              avatar: image?.absoluteString
            )
            print("Finish login")
            if res {
              await MainActor.run {
                self.navigator.navigate("/chats")
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
  
  var canRegister:Bool {
    return email.isEmail() && password.count >= 5 && displayName.count >= 5
  }
  
  var body: some View {
    Splash(mini: true) {
      VStack(spacing: 12.0) {
        Spacer()
        if loggingIn {
          Spinner().size(60.0)
        }
        Button {
          pickImage = true
        } label: {
          ZStack {
            Avatar(url: image?.absoluteString, size: 120.0)
            if localImage != nil && image == nil {
              Spinner()
            }
          }.size(120.0)
        }
        HStack {
          TextField("Display Name", text: Binding(
            get: {
              displayName
            },
            set: { value, tx in
              if CharacterSet.alphanumerics.isSuperset(of: CharacterSet(charactersIn: value)) {
                displayName = value
              }
            }))
            .textContentType(.username)
            .autocapitalization(.none)
            .submitLabel(.next)
            .focused($focus, equals: .name)
            .onSubmit {
              focus = .email
            }
            .grow()
        }
        .padding(.horizontal, 16)
        .background(Color.white)
        .cornerRadius(8)
        .height(44)
        .padding(.horizontal, 32)
        HStack {
          TextField("Email", text: $email)
            .keyboardType(.emailAddress)
            .textContentType(.emailAddress)
            .autocapitalization(.none)
            .submitLabel(.next)
            .focused($focus, equals: .email)
            .onSubmit {
              focus = .password
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
            .focused($focus, equals: .password)
            .textContentType(.newPassword)
            .submitLabel(.done)
            .onSubmit({
              register()
            })
            .grow()
        }
        .padding(.horizontal, 16)
        .background(Color.white)
        .cornerRadius(8)
        .height(44)
        .padding(.horizontal, 32)
        Spacer()
        Button {
          navigator.navigate("/login")
        } label: {
          HStack {
            Text("Already have an account?")
              .foregroundColor(.white)
            Text("Login")
              .foregroundColor(.blue)
              .underline()
          }
        }
        Button {
          register()
        } label: {
          HStack {
            HStack {
              Text("Register")
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
    }.sheet(isPresented: $pickImage) {
      PhotoPicker(onFile: { url in
        self.localImage = url
        self.image = nil
        Task.detached {
          do {
            let uploaded = try await InAppChat.uploadProfilePicture(url)
            await MainActor.run {
              self.localImage = nil
              self.image = .init(string: uploaded)!
            }
          } catch let err {
            print("err")
            await MainActor.run {
              self.localImage = nil
              self.image = nil
              self.message = "Failed to upload photo. Please try again"
              self.didError = true
            }
          }
        }
      })
    }
  }
  
}

struct Register_Previews: PreviewProvider {
  static var previews: some View {
    Register()
  }
}
