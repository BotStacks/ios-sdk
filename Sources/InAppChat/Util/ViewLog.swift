//
//  ViewLog.swift
//  InAppChat
//
//  Created by Zaid Daghestani on 2/4/23.
//

import Foundation
import SwiftUI

struct ViewLog: View {

  @EnvironmentObject var navigator: Navigator

  var body: some View {
    EmptyView()
      .onChange(
        of: navigator.path,
        perform: { path in
          print(navigator.historyStack, navigator.path)
        })
  }
}
