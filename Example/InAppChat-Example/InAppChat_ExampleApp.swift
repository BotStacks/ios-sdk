//
//  InAppChat_ExampleApp.swift
//  InAppChat-Example
//
//  Created by Zaid Daghestani on 1/24/23.
//

import InAppChat
import SwiftUI
import GiphyUISDK

@main
struct InAppChat_ExampleApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
  

  func envVar(_ name: String, defaultValue: String) -> String {
    guard let path = Bundle.main.path(forResource: "Keys", ofType: "plist") else {
      print("No Keys File")
      return defaultValue
    }
    let dict = NSDictionary(contentsOfFile: path)
    print("Got dict \(dict.debugDescription)")
    guard let val = dict?.value(forKey: name) as? String, !val.isEmpty  else {
      print("Invalid Value")
      return defaultValue
    }
    return val
  }
  
  init() {
    Giphy.configure(apiKey: envVar("giphy-api-key", defaultValue: ""))
    InAppChat.setup(apiKey: envVar("inappchat-api-key", defaultValue: ""))
    InAppChat.shared.hideBackButton = true
  }

  var body: some Scene {
    WindowGroup {
      ContentView()
    }
  }
    
}


class AppDelegate: NSObject, UIApplicationDelegate {

    func application(
      _ application: UIApplication,
      didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data
    ) {
      let tokenParts = deviceToken.map { data in String(format: "%02.2hhx", data) }
      let token = tokenParts.joined()
      print("Device Token: \(token)")
      InAppChat.registerPushToken(token)
    }
    
    func application(_ application: UIApplication,
                      didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
       return true
     }
}
