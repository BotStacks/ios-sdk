//
//  InAppChatController.swift
//  InAppChat
//
//  Created by Zaid Daghestani on 8/4/23.
//

import Foundation
import UIKit
import SwiftUI

public class InAppChatController: UINavigationController {
  
  static var instance: InAppChatController {
    return UIStoryboard(name: "InAppChat", bundle: assets).instantiateInitialViewController() as! InAppChatController
  }
  
}

public struct InAppChatView: UIViewControllerRepresentable {
  
  public init(onLogout: @escaping () -> Void) {
    InAppChat.shared.onLogout = onLogout
  }
  
  public func makeUIViewController(context: Context) -> InAppChatController {
    return InAppChatController.instance
  }
  
  public func updateUIViewController(_ uiViewController: InAppChatController, context: Context) {
    
  }
  
  public static func dismantleUIViewController(_ uiViewController: InAppChatController, coordinator: Void) {
    InAppChat.shared.onLogout = nil
  }

  public typealias UIViewControllerType = InAppChatController
  
}
