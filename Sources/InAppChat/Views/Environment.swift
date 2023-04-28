//
//  Environment.swift
//  InAppChatUI
//
//  Created by Zaid Daghestani on 1/25/23.
//

import Foundation
import SwiftUI

public struct Geometry {
  public let size: CGSize
  public let insets: EdgeInsets

  public var safeWidth: CGFloat {
    return size.width
  }

  public var safeHeight: CGFloat {
    return size.height
  }

  public var height: CGFloat {
    return size.height + insets.top + insets.bottom
  }

  public var width: CGFloat {
    return size.width + insets.leading + insets.trailing
  }
}

extension CGFloat {
  public var minusHeader: CGFloat {
    return self - Header<Image>.height
  }
  public var minusTabs: CGFloat {
    return self - Tabs.height
  }
  public var tabScreen: CGFloat {
    return self.minusHeader.minusTabs
  }
}

extension View {

  public func safeEqual(_ proxy: Geometry) -> some View {
    return frame(width: proxy.safeWidth, height: proxy.safeHeight)
  }

  public func equal(_ proxy: Geometry) -> some View {
    return frame(width: proxy.width, height: proxy.height)
  }
}

public struct GeometryKey: EnvironmentKey {
  public static let defaultValue: Geometry = Geometry(size: .zero, insets: .init())
}

public struct IACThemeKey: EnvironmentKey {
  public static let defaultValue: Theme = Theme.default
}

extension EnvironmentValues {
  public var geometry: Geometry {
    get { self[GeometryKey.self] }
    set { self[GeometryKey.self] = newValue }
  }

  public var iacTheme: Theme {
    get { self[IACThemeKey.self] }
    set { self[IACThemeKey.self] = newValue }
  }
}
