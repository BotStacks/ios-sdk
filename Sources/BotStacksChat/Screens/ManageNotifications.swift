//
//  ManageNotifications.swift
//  BotStacksChat
//
//  Created by Zaid Daghestani on 2/1/23.
//

import Foundation
import SwiftUI
import UIKit
import Combine

func c() -> Colors {
  return Theme.current.colors
}

public class UIManageNotifications: UIBaseController {
  
  @IBOutlet var all: UIView!
  @IBOutlet var mentions: UIView!
  @IBOutlet var none: UIView!
  
  @IBOutlet var update: UIButton!
  
  let settings = BotStacksChatStore.current.settings
  
  var bag = Set<AnyCancellable>()
  
  override public func viewDidLoad() {
    super.viewDidLoad()
    settings.objectWillChange.makeConnectable().autoconnect().sink { [weak self] _ in
      DispatchQueue.main.async {
        self?.updateUI()
      }
    }.store(in: &bag)
    setTheme()
    updateUI()
  }
  
  func setTheme() {
    update.tintColor = c().primary.ui
    [all, mentions, none].forEach { it in
      it?.backgroundColor = c().primary.ui
      it?.superview?.layer.borderColor = c().primary.cgColor
      it?.superview?.layer.borderWidth = 1.0
      let label = (it?.superview?.superview?.subviews.first as? UILabel)
      label?.font = Theme.current.fonts.headline
      label?.textColor = c().text.ui
    }
  }
  
  func updateUI() {
    let n = settings.notifications
    all.isHidden = n != .all
    mentions.isHidden = n != .mentions
    none.isHidden = n != .none
  }
  
  @IBAction func tapAll() {
    settings.notifications = .all
  }
  
  @IBAction func tapMentions() {
    settings.notifications = .mentions
  }
  
  @IBAction func tapNone() {
    settings.notifications = .none
  }
  
  @IBAction func save() {
    settings.setNotification(settings.notifications)
    self.navigationController?.popViewController(animated: true)
  }
}

public struct ManageNotifications: View {

  @ObservedObject var settings = BotStacksChatStore.current.settings
  @Environment(\.iacTheme) var theme

  public init() {}

  public var body: some View {
    VStack(alignment: .leading, spacing: 0.0) {
      Header(title: "Manage Notifications")
      HStack {
        Text("Notification status")
          .font(theme.fonts.body.font)
          .foregroundColor(theme.colors.text)
      }.padding(.leading, 16.0)
      Spacer().height(20.0)
      Button {
        settings.setNotification(.all)
        print("new notifications", settings.notifications)
      } label: {
        Option(title: "Allow All", selected: settings.notifications == .all)
      }
      Button {
        settings.setNotification(.mentions)
        print("new notifications", settings.notifications)
      } label: {
        Option(title: "Mentions Only", selected: settings.notifications == .mentions)
      }
      Button {
        settings.setNotification(.none)
        print("new notificaitons", settings.notifications)
      } label: {
        Option(title: "None", selected: settings.notifications == .none)
      }
      Spacer()
      Button {

      } label: {
        ZStack {
          Text("Update")
            .textCase(.uppercase)
            .foregroundColor(theme.colors.background)
            .font(theme.fonts.headline.font)
        }
        .height(60)
        .growX()
        .background(theme.colors.primary)
        .cornerRadius(15.0)
      }.padding(.horizontal, 16.0)
    }.padding(.bottom, 16.0).edgesIgnoringSafeArea(.top)
  }

}

private struct Option: View {
  @Environment(\.iacTheme) var theme
  let title: String
  let selected: Bool

  var body: some View {
    HStack {
      Text(title)
        .font(theme.fonts.headline.font)
        .foregroundColor(theme.colors.text)
      Spacer()
      IACRadio(selected: selected)
    }.height(64)
      .padding(.horizontal, 16)
  }
}
