//
//  Radio.swift
//  BotStacksChat
//
//  Created by Zaid Daghestani on 2/1/23.
//

import Foundation
import SwiftUI

public struct IACRadio: View {
  let selected: Bool
  @Environment(\.iacTheme) var theme

  public var body: some View {
    ZStack {
      Circle()
        .stroke(selected ? theme.colors.primary : theme.colors.caption, lineWidth: 2.0)
      if selected {
        ZStack {
          Circle().fill(theme.colors.primary)
        }.padding(.all, 4.0)
      }
    }
    .size(22.0)
    .cornerRadius(11.0)
  }
}
