//
//  NavLink.swift
//  InAppChat
//
//  Created by Zaid Daghestani on 7/8/23.
//

import Foundation
import SwiftUI



public struct NavLink<T, Content>: View where T:Equatable, Content:View {
  @EnvironmentObject var pilot: UIPilot<T>
  
  let path: T
  let content: () -> Content
  
  init(to path: T, @ViewBuilder content: @escaping () -> Content) {
    self.path = path
    self.content = content
  }
  
  public var body: some View {
    Button(action: {
      pilot.push(path)
    }, label: content)
  }
}
