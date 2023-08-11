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

public class UIPrivacyPill: UIButton {
  
  override public func awakeFromNib() {
    self.titleLabel?.font = .boldSystemFont(ofSize: 8.0)
  }
  
  func bind(chat: Chat) {
    self.layer.cornerRadius = self.frame.height / 2.0
    if chat.isDM {
      isHidden = true
    } else {
      isHidden = false
      setTitle(chat._private ? "PRIVATE" : "PUBLIC", for: .normal)
      backgroundColor = chat._private ? Theme.current.colors.public.ui : Theme.current.colors.private.ui
    }
  }
}
