import Foundation
import SwiftUI
import UIKit
import SDWebImage
import SnapKit
import Combine

public class UIChannelsController: UIViewController, UITableViewDelegate, UITableViewDataSource {
  
  @IBOutlet var tableView: UITableView!
  @IBOutlet var lblTitle: UILabel!
  @IBOutlet var btnBack: UIButton!
  @IBOutlet var emptyView: UIEmptyView!
  
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
    BotStacksChatStore
      .current
      .network
      .objectWillChange
      .makeConnectable()
      .autoconnect()
      .sink { [weak self] _ in
      DispatchQueue.main.async {
        self?.updateUI()
      }
    }.store(in: &bag)
    self.updateUI()
    BotStacksChatStore.current.network.loadMoreIfEmpty()
    self.emptyView.apply(Theme.current.assets.emptyAllChannels, cta: CTA(
      icon: nil, text: "Create A Channel", action: {
        self.performSegue(withIdentifier: "create", sender: nil)
    }))
  }
  
  var chats: [Chat] {
    return BotStacksChatStore.current.network.items
  }
  
  func updateUI() {
    if chats.isEmpty && !BotStacksChatStore.current.network.loading {
      self.emptyView.isHidden = false
    } else {
      self.emptyView.isHidden = true
    }
    self.tableView.reloadData()
  }
  
  public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return BotStacksChatStore.current.network.items.count
  }
  
  public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "channel") as! UIChannelRow
    cell.chat = BotStacksChatStore.current.network.items[indexPath.row]
    return cell
  }
  
  public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return UITableView.automaticDimension
  }
  
  public func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    BotStacksChatStore.current.network.loadMoreIfNeeded(BotStacksChatStore.current.network.items[indexPath.row])
  }
  
  public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let chat = chats[indexPath.row]
    chat.loadMoreIfEmpty()
    self.performSegue(withIdentifier: "chat", sender: chat)
  }
  
  public override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "chat" {
      let chat = segue.destination as? UIChatRoom
      chat?.chat = sender as? Chat
    }
  }
  
  @IBAction func back() {
    self.navigationController?.popViewController(animated: true)
  }
}


public struct ChannelsView: View {
  
  @Environment(\.iacTheme) var theme
  @ObservedObject var chats = BotStacksChatStore.current
  @Environment(\.geometry) var geometry
  @EnvironmentObject var navigator: Navigator
  
  @Binding var scrollToTop: Int
  public init(scrollToTop: Binding<Int>) {
    self._scrollToTop = scrollToTop
  }
  
  public var body: some View {
    ScrollViewReader { proxy in
      ZStack(alignment: .topLeading) {
        PagerList(
          pager: chats.network,
          topInset: geometry.insets.top + Header<EmptyView>.height + 20.0,
          bottomInset: geometry.insets.bottom + Tabs.height + 10.0,
          empty: {
            EmptyListView(
              loading: chats.network.loading,
              config: theme.assets.emptyAllChannels,
              tab: true,
              cta: CTA(icon: nil, text: "Create A Channel", action: {
                navigator.navigate("/groups/new")
              })
            )
          }
        ) { chat in
          ChannelRow(chat: chat)
        }.onChange(of: scrollToTop) { newValue in
          if let id = chats.network.items.first?.id {
            withAnimation {
              proxy.scrollTo(id, anchor: .top)
            }
          }
        }
        Header(
          title: "All Channels", showStartMessage: false, showSearch: true, addPath: "/groups/new"
        )
      }
    }
  }
}
