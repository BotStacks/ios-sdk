//
//  Contacts.swift
//  InAppChat
//
//  Created by Zaid Daghestani on 2/6/23.
//

import Foundation

public class ContactsPager: Pager<User> {

  @Published var requestContacts = !haveContactsPermission() && canAskForContacts()

  var contacts = [String]()

  func request() {
    self.requestContacts = false
    Task.detached {
      do {
        let permission = try await requestContactsPermission()
        if permission {
          self.contacts = fetchContacts()
          publish {
            Task {
              await self.refresh()
            }
          }
        }
      } catch {

      }
    }
  }

  override public func load(skip: Int, limit: Int) async throws -> [User] {
    return try await api.listUsers(skip: skip, limit: limit)
  }

}
