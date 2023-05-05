//
//  InAppChat_ExampleApp.swift
//  InAppChat-Example
//
//  Created by Zaid Daghestani on 1/24/23.
//

import InAppChat
import SwiftUI

@main
struct InAppChat_ExampleApp: App {

  init() {
    InAppChat.setup(namespace: "sample.ertc.com", apiKey: "oj2k3r2x")
  }

  var body: some Scene {
    WindowGroup {
      ContentView()
    }
  }
}
