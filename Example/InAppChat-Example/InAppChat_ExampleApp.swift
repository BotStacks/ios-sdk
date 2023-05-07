//
//  InAppChat_ExampleApp.swift
//  InAppChat-Example
//
//  Created by Zaid Daghestani on 1/24/23.
//

import InAppChat
import SwiftUI
import Firebase

@main
struct InAppChat_ExampleApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate


  init() {
    InAppChat.setup(namespace: "sample.ertc.com", apiKey: "oj2k3r2x")
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
       FirebaseApp.configure()
       return true
     }
}
