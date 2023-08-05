//
//  AssetImage.swift
//  InAppChat
//
//  Created by Zaid Daghestani on 2/1/23.
//

import Foundation
import SwiftUI

func AssetImage(_ name: String) -> UIImage {
  return UIImage.init(named: name, in: assets, with: nil)!
}

extension UIImage {
  public var image: Image {
    return Image(uiImage: self)
  }
}

public extension Color {
  public var ui: UIColor {
    return UIColor.init(self)
  }
}
