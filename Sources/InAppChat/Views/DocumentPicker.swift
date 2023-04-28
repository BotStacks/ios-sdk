//
//  DocumentPicker.swift
//  InAppChat
//
//  Created by Zaid Daghestani on 1/31/23.
//

import Foundation
import SwiftUI
import UIKit


struct DocumentPicker: UIViewControllerRepresentable {

  @Environment(\.presentationMode) private var presentationMode

  let audio: Bool = false
  let onFile: (URL) -> Void

  func makeCoordinator() -> DocumentPicker.Coordinator {
    return DocumentPicker.Coordinator(parent1: self)
  }

  func makeUIViewController(context: UIViewControllerRepresentableContext<DocumentPicker>)
    -> UIDocumentPickerViewController
  {
    let picker = UIDocumentPickerViewController(
      forOpeningContentTypes: audio ? [.audio] : [.fileURL], asCopy: true)
    picker.allowsMultipleSelection = false
    picker.delegate = context.coordinator
    return picker
  }

  func updateUIViewController(
    _ uiViewController: DocumentPicker.UIViewControllerType,
    context: UIViewControllerRepresentableContext<DocumentPicker>
  ) {
  }

  class Coordinator: NSObject, UIDocumentPickerDelegate {

    var parent: DocumentPicker

    init(parent1: DocumentPicker) {
      parent = parent1
    }
    func documentPicker(
      _ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]
    ) {
      print("Selected files", urls)
      if let fileURL = urls.first {
        do {
          let tmp = try copyFileToTemp(url: fileURL)
          publish {
            self.parent.onFile(tmp)
          }
        } catch let err {
          print("err failed to copy doc", err)
        }
      } else {
        print("No files picked")
      }
      print("")
    }
  }
}
