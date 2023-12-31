//
//  ContactsView.swift
//  BotStacksChat
//
//  Created by Zaid Daghestani on 2/1/23.
//

import Foundation
import SwiftUI
import UIKit
import Combine

public class UISyncContactsView: UITableViewCell {
  
  @IBAction func onPress() {
    BotStacksChatStore.current.contacts.request()
  }
  
}

public class UIContactsController: UIViewController, UITableViewDataSource, UITableViewDelegate {
  
  @IBOutlet var btnBack: UIButton!
  @IBOutlet var lblTitle: UILabel!
  @IBOutlet var tableView: UITableView!
  
  var bag = Set<AnyCancellable>()
  
  override public func viewDidLoad() {
    lblTitle.font = Theme.current.fonts.title.bold
    tableView.rowHeight = UITableView.automaticDimension
    if BotStacksChat.shared.hideBackButton {
      btnBack.snp.updateConstraints { make in
        make.width.equalTo(0)
      }
      btnBack.layer.opacity = 0
      self.lblTitle.snp.updateConstraints { make in
        make.left.equalToSuperview().inset(24.0)
      }
    }
    BotStacksChatStore.current.contacts.objectWillChange.makeConnectable().autoconnect().sink { [weak self] _ in
      DispatchQueue.main.async {
        self?.tableView.reloadData()
      }
    }.store(in: &bag)
    BotStacksChatStore.current.contacts.loadMoreIfEmpty()
  }
  
  let ct = BotStacksChatStore.current.contacts
  
  func contact(at index: IndexPath) -> User {
    return ct.items[index.row - (ct.requestContacts ? 1 : 0)]
  }
  
  public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return ct.items.count + (ct.requestContacts ? 1 : 0)
  }
  
  public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    if ct.requestContacts && indexPath.row == 0 {
      return tableView.dequeueReusableCell(withIdentifier: "requestContacts", for: indexPath)
    }
    let cell = tableView.dequeueReusableCell(withIdentifier: "contact") as! UIContactRow
    cell.user = contact(at: indexPath)
    return cell
  }
  
  public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    if ct.requestContacts && indexPath.row == 0 { return }
    let user = contact(at: indexPath)
    self.performSegue(withIdentifier: "user", sender: user)
  }
  
  public override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "user" {
      let dest = segue.destination as! UIProfile
      dest.user = sender as! User
    }
  }
  
  public func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    if ct.requestContacts && indexPath.row == 0 { return }
    BotStacksChatStore.current.contacts.loadMoreIfNeeded(contact(at: indexPath))
  }
  
  @IBAction func back() {
    self.navigationController?.popViewController(animated: true)
  }
}

public struct ContactsView: View {

  @Environment(\.iacTheme) var theme
  @Environment(\.geometry) var geometry
  @ObservedObject var contacts = BotStacksChatStore.current.contacts

  @Binding var scrollToTop: Int
  public init(scrollToTop: Binding<Int>) {
    self._scrollToTop = scrollToTop
  }

  public var body: some View {
    ScrollViewReader { proxy in
      ZStack(alignment: .topLeading) {
        PagerList(
          pager: contacts,
          topInset: geometry.insets.top + Header<EmptyView>.height,
          bottomInset: geometry.insets.bottom + Tabs.height,
          header: {
            VStack {
              if contacts.requestContacts {
                VStack(alignment: .leading) {
                  Text("Find your friends")
                    .foregroundColor(theme.inverted.text)
                    .font(theme.fonts.title3.font)
                  Text(
                    "Sync your contacts to easily find people you know. Your contacts will only be to help you connect with friends."
                  )
                  .foregroundColor(theme.inverted.text)
                  .font(theme.fonts.body.font.bold())
                  Button {
                    contacts.requestContacts = false
                    contacts.request()
                  } label: {
                    HStack {
                      Text("Sync")
                        .font(theme.fonts.body.font.bold())
                        .foregroundColor(theme.colors.text)
                    }.height(26)
                      .padding(.horizontal, 20)
                      .background(theme.colors.background)
                      .cornerRadius(13)
                  }
                }.padding(16.0)
                  .background(theme.inverted.softBackground)
                  .cornerRadius(15.0)
              }
            }
          }
        ) { contact in
          NavLink(to: contact.path) {
            ContactRow(user: contact)
          }
        }.edgesIgnoringSafeArea(.all)
          .onChange(of: scrollToTop) { newValue in
            if let id = contacts.items.first?.id {
              withAnimation {
                proxy.scrollTo(id, anchor: .top)
              }
            }
          }
        Header(title: "My Contacts", showSearch: true)
      }.onAppear {
        contacts.loadMoreIfEmpty()
      }
    }
  }
}

