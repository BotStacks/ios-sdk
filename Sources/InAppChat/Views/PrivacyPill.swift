import Foundation
import SwiftUI

public struct PrivacyPill: View {

  let _private: Bool

  @Environment(\.iacTheme) var theme

  public var body: some View {
    return Text(_private ? "Private" : "Public")
      .font(.system(size: 10.0, weight: .bold))
      .textCase(.uppercase)
      .foregroundColor(.white)
      .padding(.horizontal, 5.0)
      .padding(.vertical, 1.0)
      .background(_private ? theme.colors.private : theme.colors.public)
      .cornerRadius(.infinity)
  }
}
