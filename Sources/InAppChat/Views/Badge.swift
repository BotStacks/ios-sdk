import Foundation
import SwiftUI

public struct Badge: View {

  @Environment(\.iacTheme) var theme

  public let count: Int

  public var body: some View {
    ZStack {
      Circle().fill(theme.colors.unread)
      Text("\(count)")
        .foregroundColor(.white)
        .font(theme.fonts.body.font.bold())
    }.size(count < 10 ? 18.0 : count < 100 ? 24.0 : 30.0)
  }
}
