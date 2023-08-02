import DynamicColor
import Foundation
import SwiftUI

public struct GroupPlaceholder: View {

  @Environment(\.iacTheme) var theme
  
  let size: CGFloat
  
  init(size: CGFloat = 87.0) {
    self.size = size
  }

  public var body: some View {
    return ZStack {
      LinearGradient(
        colors: [
          Color(DynamicColor(theme.colors.primary).adjustedHue(amount: -25.0).cgColor),
          Color(DynamicColor(theme.colors.primary).adjustedHue(amount: 25.0).cgColor),
        ], startPoint: .topLeading,
        endPoint: .bottomTrailing)
      theme
        .assets
        .group
        .resizable()
        .aspectRatio(contentMode: .fit)
        .size(size / 87.0 * 50.0)
        .foregroundColor(Color.white)
    }.size(size)
  }
}
