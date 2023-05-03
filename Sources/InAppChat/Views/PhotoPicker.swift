//
//  DocumentPicker.swift
//  InAppChat
//
//  Created by Zaid Daghestani on 1/31/23.
//

import Foundation
import PhotosUI
import SwiftUI
import UIKit

struct PhotoPicker: UIViewControllerRepresentable {

  @Environment(\.presentationMode) private var presentationMode

  let video: Bool
  let onProgress: (Progress) -> Void
  let onFile: (URL) -> Void

  func makeCoordinator() -> PhotoPicker.Coordinator {
    return PhotoPicker.Coordinator(parent1: self)
  }

  func makeUIViewController(context: UIViewControllerRepresentableContext<PhotoPicker>)
    -> PHPickerViewController
  {
    var config = PHPickerConfiguration(photoLibrary: .shared())
    config.filter = video ? .videos : .images
    config.preferredAssetRepresentationMode = .current
    let picker = PHPickerViewController(configuration: config)
    picker.delegate = context.coordinator
    return picker
  }

  func updateUIViewController(
    _ uiViewController: PhotoPicker.UIViewControllerType,
    context: UIViewControllerRepresentableContext<PhotoPicker>
  ) {
  }

  class Coordinator: NSObject, PHPickerViewControllerDelegate {

    var parent: PhotoPicker

    init(parent1: PhotoPicker) {
      parent = parent1
    }

    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
      self.parent.presentationMode.wrappedValue.dismiss()
      let identifier =
        self.parent.video
        ? [UTType.video.identifier, UTType.movie.identifier, UTType.mpeg.identifier]
        : [UTType.image.identifier]
      print("picker did finsih picking", results)
      if let result = results.first,
        let match = identifier.first(where: {
          result.itemProvider.hasItemConformingToTypeIdentifier($0)
        })
      {
        print("Getting file for ", match)
        let progress = result.itemProvider.loadFileRepresentation(forTypeIdentifier: match) {
          url, err in
          if let err = err {
            print("Error Loading File", err)
          } else if let url = url {
            do {
              let tmp = try tmpFile()
              print("Copy from url", url.absoluteString, "to", tmp.absoluteString)
              try FileManager.default.copyItem(
                at: url, to: tmp)
              publish {
                self.parent.onFile(tmp)
              }
            } catch let err {
              print("Failed to copy file", err)
            }
          }
        }
        self.parent.onProgress(progress)
      } else {
        print("No picker results")
      }
    }
  }
}