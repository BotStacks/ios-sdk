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
    InAppChat.setup(namespace: "g2minusqa.qa.ertc.com", apiKey: "hz5sk9e6")
  }

  var body: some Scene {
    WindowGroup {
      ContentView()
    }
  }
}
