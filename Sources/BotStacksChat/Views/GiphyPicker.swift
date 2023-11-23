//
//  DocumentPicker.swift
//  BotStacksChat
//
//  Created by Zaid Daghestani on 1/31/23.
//

import Foundation
import GiphyUISDK
import SwiftUI
import UIKit

struct GiphyPicker: UIViewControllerRepresentable {

  @Environment(\.presentationMode) private var presentationMode

  let onFile: (URL) -> Void

  func makeCoordinator() -> GiphyPicker.Coordinator {
    return GiphyPicker.Coordinator(parent1: self)
  }

  func makeUIViewController(context: UIViewControllerRepresentableContext<GiphyPicker>)
    -> GiphyViewController
  {
    let picker = GiphyViewController()
    picker.delegate = context.coordinator
    picker.mediaTypeConfig = [.gifs]

    return picker
  }

  func updateUIViewController(
    _ uiViewController: GiphyPicker.UIViewControllerType,
    context: UIViewControllerRepresentableContext<GiphyPicker>
  ) {
  }

  class Coordinator: NSObject, GiphyDelegate {

    var parent: GiphyPicker

    init(parent1: GiphyPicker) {
      parent = parent1
    }

    func didSelectMedia(giphyViewController: GiphyViewController, media: GPHMedia) {
      if let gifURL = media.url(rendition: .fixedWidth, fileType: .gif),
         let url = URL(string: gifURL) {
        self.parent.onFile(url)
      }
      self.parent.presentationMode.wrappedValue.dismiss()
    }

    func didDismiss(controller: GiphyViewController?) {
      self.parent.presentationMode.wrappedValue.dismiss()
    }
  }
}
