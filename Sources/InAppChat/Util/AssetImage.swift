//
//  AssetImage.swift
//  InAppChat
//
//  Created by Zaid Daghestani on 2/1/23.
//

import Foundation
import SwiftUI

func AssetImage(_ name: String) -> Image {
  return Image(name, bundle: assets)
}

