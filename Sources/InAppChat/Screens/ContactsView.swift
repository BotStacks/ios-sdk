//
//  ContactsView.swift
//  InAppChat
//
//  Created by Zaid Daghestani on 2/1/23.
//

import Foundation
import SwiftUI
import UIKit
import Combine

public class UISyncContactsView: UITableViewCell {
  
  @IBAction func onPress() {
    Chats.current.contacts.request()
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
    if InAppChat.shared.hideBackButton {
      btnBack.snp.updateConstraints { make in
        make.width.equalTo(0)
      }
      btnBack.layer.opacity = 0
      self.lblTitle.snp.updateConstraints { make in
        make.left.equalToSuperview().inset(24.0)
      }
    }
    Chats.current.contacts.objectWillChange.makeConnectable().autoconnect().sink { [weak self] _ in
      DispatchQueue.main.async {
        self?.tableView.reloadData()
      }
    }.store(in: &bag)
    Chats.current.contacts.loadMoreIfEmpty()
  }
  
  public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    if Chats.current.contacts.requestContacts {
      return tableView.dequeueReusableHeaderFooterView(withIdentifier: "request")
    }
    return nil
  }
  
  public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return Chats.current.contacts.items.count
  }
  
  public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "channel") as! UIContactRow
    cell.user = Chats.current.contacts.items[indexPath.row]
    return cell
  }
  
  public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let user = Chats.current.contacts.items[indexPath.row]
    self.performSegue(withIdentifier: "user", sender: user)
  }
  
  public override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "user" {
      let dest = segue.destination as! UIProfile
      dest.user = sender as! User
    }
  }
  
  public func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    Chats.current.contacts.loadMoreIfNeeded(Chats.current.contacts.items[indexPath.row])
  }
  
  @IBAction func back() {
    self.navigationController?.popViewController(animated: true)
  }
}

public struct ContactsView: View {

  @Environment(\.iacTheme) var theme
  @Environment(\.geometry) var geometry
  @ObservedObject var contacts = Chats.current.contacts

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

