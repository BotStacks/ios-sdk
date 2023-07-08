//
//  ContactsView.swift
//  InAppChat
//
//  Created by Zaid Daghestani on 2/1/23.
//

import Foundation
import SwiftUI

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
                    .font(theme.fonts.title3)
                  Text(
                    "Sync your contacts to easily find people you know. Your contacts will only be to help you connect with friends."
                  )
                  .foregroundColor(theme.inverted.text)
                  .font(theme.fonts.body.bold())
                  Button {
                    contacts.requestContacts = false
                    contacts.request()
                  } label: {
                    HStack {
                      Text("Sync")
                        .font(theme.fonts.body.bold())
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
