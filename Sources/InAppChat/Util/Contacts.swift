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

var contactCache: [String: CNContact] = [:]

extension CNContact {
  func toAppContact() -> String {
    return String(data: try! CNContactVCardSerialization.data(with: [self]), encoding: .utf8)!
  }
  
  static func fromVCard(_ data: String) -> CNContact? {
    if let cached = contactCache[data] {
      return cached
    }
    if let contact = try? CNContactVCardSerialization.contacts(with: data.data(using: .utf8)!).first {
      contactCache[data] = contact
      return contact
    }
    return nil
  }
}

extension CNContact {
  
  var displayName: String {
    return [self.givenName, self.middleName, self.familyName].compactMap({$0}).filter({
      !$0.isEmpty
    }).join(" ")
  }
  
  var numbers: [(type: String, number: String)] {
    return self.phoneNumbers.map({ (type: $0.label.map({CNLabeledValue<NSString>.localizedString(forLabel: $0)}) ?? "", number: $0.value.stringValue) })
  }
  
  var emails: [(type: String, email: String)] {
    return self.emailAddresses.map({ (type: $0.label.map({CNLabeledValue<NSString>.localizedString(forLabel: $0)}) ?? "", email: $0.value as String) })
  }
  
  var markdown: String {
    return """
      \(displayName)
      \(numbers.map({"[\(($0.type).isEmpty ? "" : "\($0.type): ")\($0.number)](tel:\($0.number))"}).join("\n") )
      \(emails.map({"[\(($0.type).isEmpty ? "" : "\($0.type): ")\($0.email)](mailto:\($0.email))"}).join("\n") )
      """
  }
}

extension Gql.FMessage.Attachment {
  var contact: CNContact? {
    if self.type.value == .vcard {
      return self.data.flatMap { CNContact.fromVCard($0)}
    }
    return nil
  }
}
