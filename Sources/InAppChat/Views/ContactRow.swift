//
//  ContactRow.swift
//  InAppChat
//
//  Created by Zaid Daghestani on 2/2/23.
//

import Foundation
import SwiftUI
import UIKit
import Combine



public class UIContactRow: UITableViewCell {

  @IBOutlet var avatar: UIImageView!
  @IBOutlet var icon: UIImageView!
  @IBOutlet var title: UILabel!
  @IBOutlet var contact: UIImageView!
  @IBOutlet var status: UILabel!
  
  var bag = Set<AnyCancellable>()
  
  var user: User! {
    didSet {
      bag.forEach {$0.cancel()}
      bag.removeAll()
      user.objectWillChange.makeConnectable().autoconnect()
        .sink { [weak self] _ in
          self?.bindUI()
        }.store(in: &bag)
      bindUI()
    }
  }
  
  func bindUI() {
    if let image = user.avatar {
      avatar.sd_setImage(with: image.url)
      icon.isHidden = true
      avatar.isHidden = false
    } else {
      icon.isHidden = false
      avatar.isHidden = true
    }
    title.text = user.displayNameFb
    contact.isHidden = user.haveContact
    status.text = user.status.rawValue
    status.textColor = user.status == .online ? Theme.current.colors.primary.ui : Theme.current.colors.text.ui
  }
}

public struct ContactRow: View {

  @Environment(\.iacTheme) var theme

  let user: User

  static let blue = Color(hex: 0x488AC7)

  public var body: some View {
    HStack(spacing: 12) {
      Avatar(url: user.avatar, size: 60)
      VStack(alignment: .leading) {
        HStack {
          Text(user.username)
            .lineLimit(1)
            .font(theme.fonts.title3.font)
            .foregroundColor(theme.colors.text)
          if user.haveContact {
            AssetImage("address-book-fill")
              .image
              .resizable()
              .foregroundColor(ContactRow.blue)
              .size(18.0)
          }
        }
        Text(user.status.rawValue.capitalized)
          .font(theme.fonts.body.font)
          .foregroundColor(user.status == .online ? theme.colors.primary : theme.colors.text)
      }
      Spacer()
    }
    .padding(.vertical, 12)
    .padding(.leading, 16.0)
    .height(84)
    .growX()
  }
}
