//
//  GifImageView.swift
//  InAppChat
//
//  Created by Zaid Daghestani on 3/3/23.
//

import Foundation
import SwiftUI
import NukeUI


public struct GifImageView: View {
  let url: URL
  public init(url: String) {
    self.url = try! url.asURL()
  }
  
  public init(url: URL) {
    self.url = url
  }
  
  public var body: some View {
    LazyImage(url: url) {
      state in
          if let container = state.imageContainer {
            if container.type == .gif, let data = container.data {
                GIFImage(data: data)
              } else {
                state.image // Use the default view
              }
          }
    }
  }
}
