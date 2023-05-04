//
//  Color.swift
//  InAppChat
//
//  Created by Zaid Daghestani on 2/1/23.
//

import Foundation
import SwiftUI

public extension Color {
  func new() -> Color {
    return Color(self.cgColor!)
  }
}
