//
//  Spinner.swift
//  BotStacksChat
//
//  Created by Zaid Daghestani on 2/1/23.
//

import ActivityIndicatorView
import Foundation
import SwiftUI

public struct Spinner: View {

  @Environment(\.iacTheme) var theme
  
  public init() {}

  public var body: some View {
    ZStack {
      ActivityIndicatorView(
        isVisible: Binding(get: { true }, set: { _ in }),
        type: .rotatingDots(count: 5)
      ).foregroundColor(theme.colors.primary)
    }
  }
}

public struct SpinnerList: View {
  public var body: some View {
    ZStack {
      Spinner()
        .size(64)
    }.padding(.all, 64.0)
      .grow()
  }
}
