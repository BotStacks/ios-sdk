import ActivityIndicatorView
import Foundation
import SwiftUI
import UIKit

struct CTA  {
  let icon: UIImage?
  let text: String
  let action: () -> Void
}

public class UIEmptyView: UIView {
  
  public required init?(coder: NSCoder) {
    super.init(coder: coder)
  }
  
  public override init(frame: CGRect) {
    super.init(frame: frame)
  }
  
  @IBOutlet var image: UIImageView!
  @IBOutlet var caption: UILabel!
  @IBOutlet var button: UIButton!
  
  override public func awakeFromNib() {
    self.caption.font = Theme.current.fonts.title2Regular
    self.caption.textColor = c().text.ui
    self.button.setTitleColor(c().text.ui, for: .normal)
    self.button.layer.borderColor = c().text.cgColor
    self.button.titleLabel?.font = Theme.current.fonts.headline
  }
  
  var cta: CTA?
  
  func apply(_ config: EmptyScreenConfig, cta: CTA?) {
    image.image = config.image
    if let text = config.caption {
      caption.attributedText = NSAttributedString(try! AttributedString(markdown: text))
    } else {
      caption.attributedText = .init("")
    }
    self.cta = cta
    if let cta = cta {
      button.setTitle(cta.text, for: .normal)
      button.setImage(cta.icon, for: .normal)
      button.isHidden = false
    } else {
      button.isHidden = true
    }
  }
  
  @IBAction func onClick() {
    cta?.action()
  }
}


public struct EmptyListView: View {
  var loading: Bool
  let config: EmptyScreenConfig
  let tab: Bool
  let extraHeight: CGFloat
  let cta: CTA?
  

  init(
    loading: Bool,
    config: EmptyScreenConfig,
    tab: Bool = false,
    extraHeight: CGFloat = 0.0,
    cta: CTA?
  ) {
    self.loading = loading
    self.config = config
    self.tab = tab
    self.extraHeight = extraHeight
    self.cta = cta
  }
  
  

  @Environment(\.iacTheme) var theme

  public var body: some View {
    ZStack(alignment: .center) {
      if loading {
        SpinnerList()
      } else {
        VStack {
          Spacer()
          if let image = config.image {
            image.image
          }
          if let caption = config.caption {
            Text(.init(caption))
              .multilineTextAlignment(.center)
              .font(theme.fonts.title2Regular.font)
              .foregroundColor(theme.colors.text)
          }
          Spacer()
          if let cta = cta {
            CTAView(icon: cta.icon?.image, text: cta.text, action: cta.action)
          }
            
        }
      }
    }.padding(.all, 16.0)
  }
  
  @ViewBuilder
  func CTAView(icon:Image?, text: String, action: @escaping () -> Void) -> some View {
    Spacer()
    VStack {
      Button(action: action) {
        HStack {
          Spacer()
          if let image = icon {
            image
              .resizable()
              .size(32.0)
              .foregroundColor(theme.colors.text)
          }
          Text(text)
            .textCase(.uppercase)
            .font(theme.fonts.headline.font)
            .foregroundColor(theme.colors.text)
          Spacer()
        }.height(60.0)
          .overlay(
            RoundedRectangle(cornerRadius: 30)
              .stroke(theme.colors.text, lineWidth: 2.0)
          )
      }
    }.padding(.horizontal, 32.0)
  }
  
}

