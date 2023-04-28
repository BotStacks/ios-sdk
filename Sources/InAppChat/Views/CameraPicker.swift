//
//  CameraPicker.swift
//  InAppChat
//
//  Created by Zaid Daghestani on 2/2/23.
//

import Foundation
import Photos
import SwiftUI
import UIKit

public struct CameraPicker: UIViewControllerRepresentable {

  var sourceType: UIImagePickerController.SourceType = .camera
  let video: Bool
  let onFile: (URL) -> Void

  public init(video: Bool = false, onFile: @escaping (URL) -> Void) {
    self.video = video
    self.onFile = onFile
  }

  @Environment(\.presentationMode) private var presentationMode

  public func makeUIViewController(context: UIViewControllerRepresentableContext<CameraPicker>)
    -> UIImagePickerController
  {

    let imagePicker = UIImagePickerController()
    imagePicker.allowsEditing = false
    imagePicker.sourceType = sourceType
    imagePicker.mediaTypes = video ? [UTType.movie.identifier] : [UTType.image.identifier]
    imagePicker.delegate = context.coordinator

    return imagePicker
  }

  public func updateUIViewController(
    _ uiViewController: UIImagePickerController,
    context: UIViewControllerRepresentableContext<CameraPicker>
  ) {

  }

  public func makeCoordinator() -> Coordinator {
    Coordinator(self)
  }

  final public class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate
  {

    var parent: CameraPicker

    init(_ parent: CameraPicker) {
      self.parent = parent
    }

    public func imagePickerController(
      _ picker: UIImagePickerController,
      didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]
    ) {
      if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
        Task.detached {
          do {
            let file = try tmpFile()
            if let png = image.pngData() {
              try png.write(to: file)
              await MainActor.run {
                self.parent.onFile(file)
              }
            } else {
              print("NO IMAGE DATA")
            }
          } catch let err {
            print(err)
          }
        }
      }

      parent.presentationMode.wrappedValue.dismiss()
    }
  }
}
