//
//  ContactRow.swift
//  InAppChat
//
//  Created by Zaid Daghestani on 2/2/23.
//

import Foundation
import SwiftUI

public struct ContactRow: View {

  @Environment(\.iacTheme) var theme

  let user: User

  static let blue = Color(hex: 0x488AC7)

  public var body: some View {
    HStack(spacing: 12) {
      Avatar(url: user.avatar, size: 60)
      VStack(alignment: .leading) {
        HStack {
          Text(user.username)
            .lineLimit(1)
            .font(theme.fonts.title3)
            .foregroundColor(theme.colors.text)
          if user.haveContact {
            AssetImage("address-book-fill")
              .resizable()
              .foregroundColor(ContactRow.blue)
              .size(18.0)
          }
        }
        Text(user.status.rawValue.capitalized)
          .font(theme.fonts.body)
          .foregroundColor(user.status == .online ? theme.colors.primary : theme.colors.text)
      }
      Spacer()
    }
    .padding(.vertical, 12)
    .padding(.leading, 16.0)
    .height(84)
    .growX()
  }
}
