//
//  ClearModalBackground.swift
//  BotStacksChat
//
//  Created by Zaid Daghestani on 2/8/23.
//

import Foundation
import SwiftUI
public struct BackgroundClearView: UIViewRepresentable {
    public func makeUIView(context: Context) -> UIView {
        let view = UIView()
        DispatchQueue.main.async {
            view.superview?.superview?.backgroundColor = .clear
        }
        return view
    }

    public func updateUIView(_ uiView: UIView, context: Context) {}
}
