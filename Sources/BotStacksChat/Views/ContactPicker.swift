//
//  ContactPicker.swift
//  BotStacksChat
//
//  Created by Zaid Daghestani on 2/8/23.
//

import Foundation
import ContactsUI
import SwiftUI


public struct ContactPicker: UIViewControllerRepresentable {

  
  let onContact: (CNContact) -> Void
  
  public init(onContact: @escaping (CNContact) -> Void) {
    self.onContact = onContact
  }
  
  @Environment(\.presentationMode) private var presentationMode

  public func makeUIViewController(context: UIViewControllerRepresentableContext<ContactPicker>)
    -> CNContactPickerViewController
  {

    let picker = CNContactPickerViewController()
    picker.delegate = context.coordinator

    return picker
  }

  public func updateUIViewController(
    _ uiViewController: CNContactPickerViewController,
    context: UIViewControllerRepresentableContext<ContactPicker>
  ) {

  }

  public func makeCoordinator() -> Coordinator {
    Coordinator(self)
  }

  public final class Coordinator: NSObject, CNContactPickerDelegate, UINavigationControllerDelegate
  {

    var parent: ContactPicker

    init(_ parent: ContactPicker) {
      self.parent = parent
    }

    public func contactPicker(_ picker: CNContactPickerViewController, didSelect contact: CNContact) {
      self.parent.onContact(contact)
      self.parent.presentationMode.wrappedValue.dismiss()
    }
    
    public func contactPickerDidCancel(_ picker: CNContactPickerViewController) {
      self.parent.presentationMode.wrappedValue.dismiss()
    }
  }
}
