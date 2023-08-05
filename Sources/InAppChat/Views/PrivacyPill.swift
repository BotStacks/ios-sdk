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
  public override init(frame: CGRect) {
    super.init(frame: frame)
  }
  
  public required init?(coder: NSCoder) {
    super.init(coder: coder)
  }
  
  func bind(chat: Chat) {
    if chat.isDM {
      isHidden = true
    } else {
      isHidden = false
      setTitle(chat._private ? "Private" : "Public", for: .normal)
      backgroundColor = chat._private ? Theme.current.colors.public.ui : Theme.current.colors.private.ui
    }
  }
}
