//
//  NavLink.swift
//  InAppChat
//
//  Created by Zaid Daghestani on 7/8/23.
//

import Foundation
import SwiftUI



public struct NavLink<Content>: View where Content:View {
  @EnvironmentObject var navigator: Navigator
  
  let path: String
  let content: () -> Content
  
  init(to path: String, @ViewBuilder content: @escaping () -> Content) {
    self.path = path
    self.content = content
  }
  
  public var body: some View {
    Button(action: {
      navigator.navigate(path)
    }, label: content)
  }
}
