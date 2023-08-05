import DynamicColor
import Foundation
import SwiftUI
import UIKit

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
        .group.image
        .resizable()
        .aspectRatio(contentMode: .fit)
        .size(size / 87.0 * 50.0)
        .foregroundColor(Color.white)
    }.size(size)
  }
}

public class GradientView: UIView {
  var startColor: UIColor?
  var endColor: UIColor?
  
  public override func draw(_ rect: CGRect) {
    if let startColor = startColor,
       let endColor = endColor {
      let gradient = CAGradientLayer()
      gradient.frame = CGRect(x: 0, y: 0, width: rect.width, height: rect.height)
      gradient.colors = [startColor.cgColor, endColor.cgColor]
      gradient.startPoint = CGPoint(x: 0.0, y: 0.0)
      gradient.endPoint = CGPoint(x: 1.0, y: 1.0)
      layer.addSublayer(gradient)
    }
  }
}

public class UIGroupPlaceholder: UIView {
  public override init(frame: CGRect) {
    super.init(frame: frame)
    build()
  }
  
  public required init?(coder: NSCoder) {
    super.init(coder: coder)
    build()
  }
  
  func build() {
    let g = GradientView()
    g.startColor = .red
    g.endColor = .green
    g.translatesAutoresizingMaskIntoConstraints = false
    addSubview(g)
    g.snp.makeConstraints { make in
      make.edges.equalToSuperview()
    }
    let icon = Theme.current.assets.group
    let image = UIImageView(image: Theme.current.assets.group)
    addSubview(image)
    image.snp.makeConstraints { make in
      make.centerX.equalToSuperview()
      make.centerY.equalToSuperview()
      make.width.equalToSuperview().multipliedBy(32.0/46.0)
      make.height.equalTo(image.snp.width)
    }
  }
}
