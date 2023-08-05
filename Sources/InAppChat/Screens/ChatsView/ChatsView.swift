//
//  Threads.swift
//  InAppChat
//
//  Created by Zaid Daghestani on 1/29/23.
//

import Foundation
import SwiftUI
import UIKit
import Combine
import SnapKit

public class ChatsController: UIViewController, UITableViewDelegate, UITableViewDataSource {
  
  var isChannels = true {
    didSet {
      lblChannels.textColor = isChannels ? Theme.current.colors.primary.ui : Theme.current.colors.caption.ui
      underlineChannels.isHidden = !isChannels
      lblChats.textColor = !isChannels ? Theme.current.colors.primary.ui : Theme.current.colors.caption.ui
      underlineChats.isHidden = isChannels
      tableView.reloadData()
    }
  }
  
  @IBOutlet var lblTitle: UILabel!
  @IBOutlet var lblChannels: UILabel!
  @IBOutlet var underlineChannels: UIView!
  @IBOutlet var lblChats: UILabel!
  @IBOutlet var underlineChats: UIView!
  @IBOutlet var tableView: UITableView!
  @IBOutlet var back: UIButton!
  @IBOutlet var chatsUnread: UIButton!
  @IBOutlet var channelsUnread: UIButton!
  
  var bag = Set<AnyCancellable>()
  
  public override func viewDidLoad() {
    lblChannels.font = Theme.current.fonts.title2.bold
    lblChannels.textColor = Theme.current.colors.primary.ui
    lblChats.textColor = Theme.current.colors.caption.ui
    lblChats.font = Theme.current.fonts.title2.bold
    lblTitle.font = Theme.current.fonts.title.bold
    chatsUnread.backgroundColor = Theme.current.colors.unread.ui
    channelsUnread.backgroundColor = Theme.current.colors.unread.ui
    if InAppChat.shared.hideBackButton {
      lblTitle.snp.updateConstraints { make in
        make.width.equalTo(0)
      }
      lblTitle.layer.opacity = 0
    }
    underlineChats.backgroundColor = Theme.current.colors.primary.ui
    underlineChannels.backgroundColor = Theme.current.colors.primary.ui
    Chats.current.objectWillChange.makeConnectable().autoconnect().sink { [weak self] _ in
      DispatchQueue.main.async {
        self?.updateUI()
      }
    }.store(in: &bag)
    updateUI()
  }
  
  var dmsUnreadCount: Int {
    return Chats.current.dms.reduce(0, {$1.unreadCount + $0})
  }
  var groupsUnreadCount: Int {
    return Chats.current.dms.reduce(0, {$1.unreadCount + $0})
  }
  
  func updateUI() {
    tableView.reloadData()
    let dmsUnreadCount = self.dmsUnreadCount
    if dmsUnreadCount > 0 {
      chatsUnread.isHidden = false
      chatsUnread.setTitle(String(dmsUnreadCount), for: .normal)
    } else {
      chatsUnread.isHidden = true
    }
    let groupsUnreadCount = self.groupsUnreadCount
    if groupsUnreadCount > 0 {
      channelsUnread.isHidden = false
      channelsUnread.setTitle(String(groupsUnreadCount), for: .normal)
    } else {
      channelsUnread.isHidden = true
    }
    let totalUnread = groupsUnreadCount + dmsUnreadCount
    if (totalUnread > 0) {
      self.tabBarItem.badgeValue = String(totalUnread)
    } else {
      self.tabBarItem.badgeValue = nil
    }
  }
  
  deinit {
    bag.forEach { $0.cancel()
    }
  }
  
  public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return chats.count
  }
  
  var chats: [Chat] {
    return isChannels ? Chats.current.groups : Chats.current.dms
  }
  
  public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "thread")! as! UIThreadRow
    cell.chat = chats[indexPath.row]
    return cell
  }
  
  public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let chat = chats[indexPath.row]
    self.performSegue(withIdentifier: "chat", sender: chat)
  }
  
  public override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "chat" {
      let dest = segue.destination as! UIChatRoom
      dest.chat = sender as! Chat
    }
  }
  
  func openNetworks() {
    self.tabBarController?.selectedIndex = 1
  }
  
  func openContacts() {
    self.tabBarController?.selectedIndex = 2
  }
  
  @IBAction func tapChannels() {
    isChannels = true
  }
  
  @IBAction func tapChats() {
    isChannels = false
  }
  
  @IBAction func onBack() {
    self.navigationController?.popViewController(animated: true)
  }
}


public struct ChatsView: View {

  @State var list: Chats.List = .groups
  @ObservedObject var chats = Chats.current

  @Environment(\.iacTheme) var theme
  @Environment(\.geometry) var geometry

  @Binding var scrollToTop: Int
  
  let onExploreChannels: () -> Void
  let onSendAMessage: () -> Void
  public init(scrollToTop: Binding<Int>, onExploreChannels: @escaping () -> Void, onSendAMessage: @escaping () -> Void) {
    self._scrollToTop = scrollToTop
    self.onExploreChannels = onExploreChannels
    self.onSendAMessage = onSendAMessage
  }
  
  func currentCta() -> CTA {
    switch list {
    case .groups:
      return CTA(
        icon: nil,
        text: "Explore Channels",
        action: onExploreChannels
      )
    case .users:
      return CTA(
        icon: AssetImage("paper-plane-tilt-fill").image,
        text: "Send a Message",
        action: onSendAMessage
      )
    }
  }
  
  

  public var body: some View {
    ScrollViewReader { proxy in
      ZStack(alignment: .topLeading) {
        let empty = {
          EmptyListView(
            loading: chats.loading,
            config: theme.assets.list(list),
            tab: true,
            extraHeight: -44.0,
            cta: currentCta()
          )
        }
        let header = {
          HStack(spacing: 0) {
            ForEach(Chats.List.all, id: \.rawValue) {
              ChatTabView(
                current: $list,
                tab: $0,
                unreadCount: chats.count($0)
              )
              .growX()
            }
          }.height(44.0)
        }
        IACList(
          items: list == .groups ? chats.groups : chats.dms,
          divider: true,
          topInset: geometry.insets.top + Header<EmptyView>.height,
          bottomInset: geometry.insets.bottom + Tabs.height,
          header: header,
          empty: empty,
          content: { ThreadRow(chat: $0) }
        )
        Header(title: "Message", showStartMessage: true, showSearch: true)
      }.onChange(of: scrollToTop) { newValue in
        var id:String? = nil
        switch list {
        case .users:
          id = chats.dms.first?.id
        case .groups:
          id = chats.groups.first?.id
        }
        if let id = id {
          withAnimation {
            proxy.scrollTo(id, anchor: .top)
          }
        }
      }
    }
  }
}
