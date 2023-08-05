//
//  GroupCount.swift
//  InAppChat
//
//  Created by Zaid Daghestani on 2/2/23.
//

import Foundation
import SwiftUI

public struct GroupCount: View {
  @Environment(\.iacTheme) var theme

  public let count: Int

  public var body: some View {
    return HStack {
      AssetImage("users-fill")
        .image
        .resizable()
        .size(16.0)
        .foregroundColor(theme.colors.caption)
      Text("\(count)")
        .font(theme.fonts.timestamp.font)
        .scaleEffect(0.8)
        .foregroundColor(theme.colors.caption)
    }
  }
}
