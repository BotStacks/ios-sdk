//
//  File.swift
//  InAppChat
//
//  Created by Zaid Daghestani on 2/2/23.
//

import Contacts
import Foundation

func haveContactsPermission() -> Bool {
  let status = CNContactStore.authorizationStatus(for: .contacts)
  return status == .authorized
}

func canAskForContacts() -> Bool {
  let status = CNContactStore.authorizationStatus(for: .contacts)
  return status != .denied
}

func requestContactsPermission() async throws -> Bool {
  return try await withCheckedThrowingContinuation { c in
    CNContactStore().requestAccess(for: .contacts) {
      success, error in
      if let err = error {
        c.resume(throwing: err)
      } else {
        c.resume(returning: true)
      }
    }
  }

}

func fetchContacts() -> [String] {
  var contacts = [String]()

  let keys: [Any] = [
    CNContactFormatter.descriptorForRequiredKeys(for: .fullName),
    CNContactImageDataKey,
    CNContactEmailAddressesKey,
    CNContactPhoneNumbersKey,
    CNContactJobTitleKey,
    CNContactBirthdayKey,
    CNContactPostalAddressesKey,
  ]

  let request = CNContactFetchRequest(keysToFetch: keys as! [CNKeyDescriptor])
  let contactStore = CNContactStore()

  try? contactStore.enumerateContacts(
    with: request,
    usingBlock: { contact, _ in
      contacts.append(contentsOf: contact.phoneNumbers.map(\.value.stringValue))
    })
  return contacts
}

extension CNContact {
  func toAppContact() -> Contact {
    return Contact(
      name: [self.givenName, self.middleName, self.familyName].compactMap({$0}).filter({
        !$0.isEmpty
      }).join(" "),
      numbers: self.phoneNumbers.map({ PhoneNumber(type: $0.label.map({CNLabeledValue<NSString>.localizedString(forLabel: $0)}) ?? "", number: $0.value.stringValue) }),
      emails: self.emailAddresses.map({ Email(type: $0.label.map({CNLabeledValue<NSString>.localizedString(forLabel: $0)}) ?? "", email: $0.value as String) })
    )
  }
}
