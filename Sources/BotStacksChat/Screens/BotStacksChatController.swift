//
//  BotStacksChatController.swift
//  BotStacksChat
//
//  Created by Zaid Daghestani on 8/4/23.
//

import Foundation
import UIKit
import SwiftUI

public class BotStacksChatController: UINavigationController {
  
  static var instance: BotStacksChatController {
    return UIStoryboard(name: "BotStacksChat", bundle: assets).instantiateInitialViewController() as! BotStacksChatController
  }
  
}

public struct BotStacksChatView: UIViewControllerRepresentable {
  
  public init(onLogout: @escaping () -> Void, onDeleteAccount: (() -> Void)?) {
    BotStacksChat.shared.onLogout = onLogout
    BotStacksChat.shared.onDeleteAccount = onDeleteAccount
  }
  
  public func makeUIViewController(context: Context) -> BotStacksChatController {
    return BotStacksChatController.instance
  }
  
  public func updateUIViewController(_ uiViewController: BotStacksChatController, context: Context) {
    
  }
  
  public static func dismantleUIViewController(_ uiViewController: BotStacksChatController, coordinator: Void) {
    BotStacksChat.shared.onLogout = nil
    BotStacksChat.shared.onDeleteAccount = nil
  }

  public typealias UIViewControllerType = BotStacksChatController
  
}
