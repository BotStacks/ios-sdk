//
//  View.swift
//  BotStacksChatUI
//
//  Created by Zaid Daghestani on 1/25/23.
//

import Foundation
import SwiftUI

public struct SquareSizeModifier: ViewModifier {
  let size: CGFloat
  public func body(content: Content) -> some View {
    content.frame(width: size, height: size)
  }
}

public struct SizeModifier: ViewModifier {
  let size: CGSize
  public func body(content: Content) -> some View {
    content.frame(width: size.width, height: size.height)
  }
}

public struct WidthModifier: ViewModifier {
  let width: CGFloat
  public func body(content: Content) -> some View {
    content.frame(width: width)
  }
}

public struct HeightModifier: ViewModifier {
  let height: CGFloat?
  public func body(content: Content) -> some View {
    if let height = height {
      content.frame(height: height)
    } else {
      content
    }
  }
}

public struct GrowModifier: ViewModifier {
  public func body(content: Content) -> some View {
    content.frame(maxWidth: .infinity, maxHeight: .infinity)
  }
}

public struct GrowXModifier: ViewModifier {
  public func body(content: Content) -> some View {
    content.frame(maxWidth: .infinity)
  }
}

public struct GrowYModifier: ViewModifier {
  public func body(content: Content) -> some View {
    content.frame(maxHeight: .infinity)
  }
}

public struct CircleModifier: ViewModifier {

  let size: CGFloat
  let color: Color

  public func body(content: Content) -> some View {
    content.size(size).background(color).cornerRadius(size / 2.0)
  }
}

extension View {
  public func size(_ size: CGFloat) -> some View {
    modifier(SquareSizeModifier(size: size))
  }

  public func size(_ size: CGSize) -> some View {
    modifier(SizeModifier(size: size))
  }

  public func width(_ width: CGFloat) -> some View {
    modifier(WidthModifier(width: width))
  }

  public func height(_ height: CGFloat?) -> some View {
    modifier(HeightModifier(height: height))
  }

  public func circle(_ size: CGFloat, _ color: Color) -> some View {
    modifier(CircleModifier(size: size, color: color))
  }

  public func grow() -> some View {
    modifier(GrowModifier())
  }

  public func growX() -> some View {
    modifier(GrowXModifier())
  }

  public func growY() -> some View {
    modifier(GrowYModifier())
  }
}
