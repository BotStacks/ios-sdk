//
//  GifImageView.swift
//  InAppChat
//
//  Created by Zaid Daghestani on 3/3/23.
//

import Foundation
import SDWebImageSwiftUI
import SwiftUI

public struct GifImageView: View {
  let url: URL
  public init(url: String) {
    self.url = try! url.asURL()
  }

  public init(url: URL) {
    self.url = url
  }

  public var body: some View {
    AnimatedImage(url: url)
  }
}
