import Combine
import SwiftUI

public class UIActionItem: UIView  {
  @IBOutlet var icon: UIImageView!
  @IBOutlet var title: UILabel!
  
  override public func awakeFromNib() {
    icon.tintColor = c().text.ui
    title.font = Theme.current.fonts.headline
    title.textColor = c().text.ui
  }
}

public struct ActionItem: View {

  @Environment(\.iacTheme) var theme

  let id = UUID().uuidString
  let image: Image?
  let text: String
  let divider: Bool
  let action: () -> Void
  public init(image: Image? = nil, text: String, divider: Bool = true, action: @escaping () -> Void)
  {
    self.image = image
    self.text = text
    self.divider = divider
    self.action = action
  }

  public var body: some View {
    Button(action: action) {
      VStack(alignment: .leading) {
        HStack {
          if let icon = image {
            icon
              .resizable()
              .size(25)
              .foregroundColor(theme.colors.text)
          }
          Text(.init(text))
            .font(theme.fonts.headline.font)
            .foregroundColor(theme.colors.text)
          Spacer()
        }
        .padding(.horizontal, 16.0)
        .padding(.vertical, 12.0)
        .height(50)
        .growX()
        if divider {
          Divider()
            .overlay(theme.colors.caption)
        }
      }.growX()
    }
  }
}

public struct ActionSheet<Content>: View where Content: View {

  @Environment(\.iacTheme) var theme
  @Environment(\.dismiss) var dismiss
  @Environment(\.geometry) var geometry

  let outOfFocusOpacity: CGFloat = 0.7
  let minimumDragDistanceToHide: CGFloat = 150.0
  let items: () -> Content

  public init(
    @ViewBuilder items: @escaping () -> Content
  ) {
    self.items = items
  }

  func hide() {
    dismiss()
  }

  var topHalfMiddleBar: some View {
    Capsule()
      .frame(width: 36, height: 5)
      .foregroundColor(theme.colors.caption)
      .padding(.vertical, 5.5)
      .opacity(0.2)
  }

  var outOfFocusArea: some View {
    GreyOutOfFocusView(opacity: outOfFocusOpacity) {
      dismiss()
    }
  }

  var sheetView: some View {
    VStack {
      Spacer()
      VStack {
        topHalfMiddleBar
        VStack {
          items()
        }.growX()
          .padding(.bottom, geometry.insets.bottom)
          .background(theme.colors.background)
          .cornerRadius(15)
      }
    }
  }

  public var body: some View {
    ZStack {
      outOfFocusArea
      sheetView
    }
  }
}
struct ActionSheetCard_Previews: PreviewProvider {
  static var previews: some View {
    VStack {
      Spacer()
      ActionSheet {
        ActionItem(image: nil, text: "Play") {

        }
        ActionItem(image: nil, text: "Stop") {

        }
        ActionItem(image: nil, text: "Record") {

        }
      }
    }
  }
}
