import ActivityIndicatorView
import Foundation
import SwiftUI
import UIKit

struct CTA  {
  let icon: Image?
  let text: String
  let action: () -> Void
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
            image
          }
          if let caption = config.caption {
            Text(.init(caption))
              .multilineTextAlignment(.center)
              .font(theme.fonts.title2Regular)
              .foregroundColor(theme.colors.text)
          }
          Spacer()
          if let cta = cta {
            CTAView(icon: cta.icon, text: cta.text, action: cta.action)
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
            .font(theme.fonts.headline)
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



