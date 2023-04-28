//
//  NavigationTransition.swift
//  InAppChat
//
//  Created by Zaid Daghestani on 2/4/23.
//

import Foundation
import SwiftUI

public struct NavigationTransition: ViewModifier {
  @EnvironmentObject private var navigator: Navigator

  public func body(content: Content) -> some View {
    if #available(iOS 16.0, *) {
      content
        .animation(.easeInOut, value: navigator.path)
        .transition(
          AnyTransition.asymmetric(
            insertion: .push(
              from: .trailing
            ), removal: .push(from: .leading))
        )
    } else {
      // Fallback on earlier versions
      content
        .animation(.easeInOut, value: navigator.path)
        .transition(
          AnyTransition.asymmetric(
            insertion: .move(edge: .trailing), removal: .move(edge: .leading)))
    }
  }
}

extension View {
  public func navigationTransition() -> some View {
    modifier(NavigationTransition())
  }
}
