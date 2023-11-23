//
//  Row.swift
//  BotStacksChat
//
//  Created by Zaid Daghestani on 2/1/23.
//

import Foundation
import SwiftUI
import UIKit

public class UIRow: UIView {
  
  override public func awakeFromNib() {
    buildUI()
  }
  
  @IBOutlet var icon: UIImageView!
  @IBOutlet var indicator: UIImageView!
  @IBOutlet var title: UILabel!
  var destructive: Bool = false {
    didSet {
      if (destructive) {
        icon?.tintColor = Theme.current.colors.destructive.ui
        title?.tintColor = Theme.current.colors.destructive.ui
      } else {
        icon?.tintColor = Theme.current.colors.text.ui
        title?.tintColor = Theme.current.colors.text.ui
      }
    }
  }
  
  func buildUI() {
    self.destructive = destructive ? true : false
    title.font = Theme.current.fonts.title3.bold
  }
}

public struct Row: View {

  @Environment(\.iacTheme) var theme

  let icon: String
  let text: String
  let iconPrimary: Bool
  let destructive: Bool

  public init(icon: String, text: String, iconPrimary: Bool = false, destructive: Bool = false) {
    self.icon = icon
    self.text = text
    self.iconPrimary = iconPrimary
    self.destructive = destructive
  }

  public var body: some View {
    VStack {
      HStack(spacing: 22.0) {
        Image(icon, bundle: assets).resizable().size(35.0)
          .foregroundColor(
            destructive
              ? theme.colors.destructive : iconPrimary ? theme.colors.primary : theme.colors.caption
          )
        Text(.init(text))
          .font(theme.fonts.title3.font.bold())
          .foregroundColor(destructive ? theme.colors.destructive : theme.colors.text)
        Spacer()
        Image(systemName: "chevron.right")
          .resizable()
          .scaledToFit()
          .foregroundColor(destructive ? theme.colors.destructive : theme.colors.caption)
          .size(16.0)
      }
      .padding(16.0)
      .height(75)
      Divider()
        .foregroundColor(theme.colors.softBackground)
    }
  }
}
