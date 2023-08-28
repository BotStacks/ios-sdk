//
//  GroupDrawer.swift
//  InAppChat
//
//  Created by Zaid Daghestani on 2/10/23.
//

import Foundation
import SwiftUI
import SDWebImage
import Combine

public class UIGroupDrawer: UIViewController, UITableViewDelegate, UITableViewDataSource {
  
  var sub: AnyCancellable? = nil
  
  var chat: Chat! {
    didSet {
      sub?.cancel()
      sub = chat.objectWillChange
        .makeConnectable()
        .autoconnect()
        .sink(receiveValue: { [weak self] _ in
          DispatchQueue.main.async {
            if self?.viewIfLoaded != nil {
              self?.bindUI()
            }
          }
        })
      if self.viewIfLoaded != nil {
        self.bindUI()
      }
    }
  }
  
  @IBOutlet var content: UIView!
  @IBOutlet var placeholder: UIGroupPlaceholder!
  @IBOutlet var image: SDAnimatedImageView!
  @IBOutlet var name: UILabel!
  @IBOutlet var desc: UILabel!
  @IBOutlet var allmembers: UILabel!
  @IBOutlet var countImage: UIImageView!
  @IBOutlet var count: UILabel!
  @IBOutlet var tableView: UITableView!
  @IBOutlet var edit: UIButton!
  @IBOutlet var invite: UIButton!
  @IBOutlet var leave: UIButton!
  @IBOutlet var report: UIButton!
  
  override public func viewDidLoad() {
    content.backgroundColor = c().background.ui
    if let i = chat.image {
      placeholder.isHidden = true
      image.sd_setImage(with: i.url)
    } else {
      placeholder.isHidden = false
      image.isHidden = true
    }
    let t = Theme.current
    let c = t.colors
    let f = t.fonts
    name.font = f.title2
    name.textColor = c.text.ui
    desc.font = f.body
    desc.textColor = c.caption.ui
    allmembers.font = f.headline
    allmembers.textColor = c.text.ui
    countImage.tintColor = c.caption.ui
    count.textColor = c.caption.ui
    count.font = f.caption
    
    edit.titleLabel?.font = f.mini
    invite.titleLabel?.font = f.mini
    leave.titleLabel?.font = f.mini
    
    tableView.separatorStyle = .none
    report.tintColor = c.unread.ui
    bindUI()
  }
  
  func bindUI() {
    name.text = chat.displayName
    desc.text = chat.description
    count.text = String(chat.activeMembers.count)
    if let membership = chat.membership {
      if !membership.isAdmin {
        edit.removeFromSuperview()
      } else if edit.superview == nil {
        (invite.superview as? UIStackView)?.insertArrangedSubview(edit, at: 0)
      }
    } else {
      edit.removeFromSuperview()
    }
    var cells = [(String, User?)]()
    cells.append(("ADMIN", nil))
    cells.append(contentsOf: chat.admins.map({("user", $0)}))
    if !chat.onlineNotAdminUsers.isEmpty {
      cells.append(("MEMBERS - ONLINE", nil))
      cells.append(contentsOf: chat.onlineNotAdminUsers.map({("user", $0)}))
    }
    if !chat.offlineUsers.isEmpty {
      cells.append(("MEMBERS", nil))
      cells.append(contentsOf: chat.offlineUsers.map({("user", $0)}))
    }
    self.cells = cells
    
    if chat.isMember {
      leave.setAttributedTitle(.init(string: chat.isAdmin ? "Delete" : "Leave", attributes: [.font: Theme.current.fonts.mini]), for: .normal)
      leave.setImage(UIImage(systemName: "trash.fill"), for: .normal)
    } else {
      leave.setAttributedTitle(.init(string: "Join", attributes: [.font: Theme.current.fonts.mini]), for: .normal)
      leave.setImage(UIImage(systemName: "plus"), for: .normal)
    }
  }
  
  @IBAction func leaveChat() {
    if chat.isAdmin {
      let alert = UIAlertController(title: "Permanently Delete \(chat.displayName)?", message: "Are you sure? This action is none reversable.", preferredStyle: .alert)
      alert.addAction(.init(title: "Cancel", style: .cancel))
      alert.addAction(.init(title: "Permanently Delete", style: .destructive, handler: { _ in
        Task.detached {
          do {
            try await api.deleteChat(id:self.chat.id)
          } catch let err {
            Monitoring.error(err)
          }
        }
        self.dismiss(animated: true)
        if let nav = self.room?.navigationController {
          nav.popToRootViewController(animated: true)
          nav.view.makeToast("Chat deleted")
        }
      }))
      self.present(alert, animated:true)
    } else if chat.isMember {
      chat.leave()
      self.dismiss(animated: true)
      self.room?.navigationController?.popViewController(animated: true)
    } else {
      if !chat._private || chat.hasInvite {
        chat.join()
      } else {
        self.view.makeToast("This is a private chat. You must be invited in order to join.")
      }
    }
  }
  
  var room: UIViewController!
  
  
  @IBAction func editChat() {
    self.dismiss(animated: true)
    self.room?.performSegue(withIdentifier: "edit", sender: chat)
  }
  
  @IBAction func inviteFriends() {
    self.dismiss(animated: true)
    self.room?.performSegue(withIdentifier: "invite", sender: chat)
  }
  
  func select(user: User) {
    self.dismiss(animated: true)
    self.room?.performSegue(withIdentifier: "user", sender: user)
  }
  
  var cells: [(String, User?)] = [] {
    didSet {
      tableView?.reloadData()
    }
  }
  
  public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return cells.count
  }
  
  public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let data = cells[indexPath.row]
    if data.0 != "user" {
      let header = tableView.dequeueReusableCell(withIdentifier: "header") as! UIGroupHeaderCell
      header.label.text = data.0
      return header
    } else {
      let cell = tableView.dequeueReusableCell(withIdentifier: "contact") as! UIContactRow
      cell.user = data.1
      return cell
    }
  }
  
  public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    let cell = cells[indexPath.row]
    if cell.0 != "user" {
      return 40.0
    } else {
      return 84.0
    }
  }
  
  public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let cell = cells[indexPath.row]
    if cell.0 == "user", let user = cell.1 {
      select(user: user)
    }
  }
  
  @IBAction func onTapBG() {
    self.dismiss(animated: true)
  }
  
  public override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "flag" {
      let controller = segue.destination as? UIFlagController
      controller?.chat = chat
      controller?.onSubmit = {
        self.dismiss(animated: true)
        self.view.makeToast("Chat reported. Thank you.")
      }
    }
  }
}

public class UIGroupHeaderCell: UITableViewCell {
  @IBOutlet var label: UILabel!
}

public struct GroupDrawer: View {

  @Environment(\.iacTheme) var theme
  @Environment(\.geometry) var geometry
  @EnvironmentObject var navigator: Navigator
  @Environment(\.dismiss) var dismiss

  @ObservedObject var chat: Chat

  @State var delete = false
  @State var leave = false

  public init(_ chat: Chat) {
    self.chat = chat
  }

  public var body: some View {
    ActionSheet {
      ZStack(alignment: .bottom) {
        VStack(alignment: .leading, spacing: 0) {
          VStack(spacing: 0) {
            Spacer().height(24)
            if let image = chat.displayImage {
              GifImageView(url: image.url!)
                .circle(70, .clear)
            } else {
              GroupPlaceholder(size: 70)
            }
            Spacer().height(12)
            Text(chat.displayName)
              .font(theme.fonts.title2.font)
              .foregroundColor(theme.colors.text)
            Text(chat.description ?? "")
              .font(theme.fonts.body.font)
              .foregroundColor(theme.colors.caption)
            Spacer().height(26)
            Divider().overlay(theme.colors.text).opacity(0.1)
          }.padding(.horizontal, 64)
            .padding(.bottom, 24)
            .padding(.top, 24)
          HStack(spacing: 0) {
            Text("All Members")
              .font(theme.fonts.headline.font)
              .foregroundColor(theme.colors.text)
            Spacer().width(14)
            AssetImage("users-three-fill")
              .image
              .resizable()
              .size(16)
              .foregroundColor(theme.colors.caption)
            Text("\(chat.activeMembers.count)")
              .font(theme.fonts.caption.font)
              .foregroundColor(theme.colors.caption)
          }
          header("Admin")
          ForEach(chat.admins) { user in
            Button {
              dismiss()
              navigator.navigate(user.path)
            } label: {
              ContactRow(user: user)
            }
          }
          if !chat.onlineNotAdminUsers.isEmpty {
            header("members - online")
            ForEach(chat.onlineNotAdminUsers) { user in
              Button {
                dismiss()
                navigator.navigate(user.path)
              } label: {
                ContactRow(user: user)
              }
            }
          }
          if !chat.offlineUsers.isEmpty {
            header("members")
            ForEach(chat.offlineUsers) { user in
              Button {
                dismiss()
                navigator.navigate(user.path)
              } label: {
                ContactRow(user: user)
              }
            }
          }
          Spacer().height(geometry.insets.bottom + 72)
        }.listStyle(.plain)
          .listItemTint(.clear)
        HStack(spacing: 4) {
          if chat.isAdmin {
            Button {
              dismiss()
              navigator.navigate(chat.editPath)
            } label: {
              ZStack {
                VStack(spacing: 0) {
                  AssetImage("gear-fill")
                    .image
                    .resizable()
                    .size(24)
                    .foregroundColor(theme.colors.border)
                  Text("Edit")
                    .font(theme.fonts.mini.font)
                    .foregroundColor(theme.colors.border)
                }
              }.size(60)
            }
          }
          Button {
            dismiss()
            navigator.navigate(chat.invitePath)
          } label: {
            ZStack {
              VStack(spacing: 0) {
                AssetImage("archive-box-fill")
                  .image
                  .resizable()
                  .size(24)
                  .foregroundColor(theme.colors.border)
                Text("Invite")
                  .font(theme.fonts.mini.font)
                  .foregroundColor(theme.colors.border)
              }
            }.size(60)
          }
          Button {
            if chat.isAdmin {
              self.delete = true
            } else {
              self.leave = true
            }
          } label: {
            ZStack {
              VStack(spacing: 0) {
                AssetImage("trash-fill")
                  .image
                  .resizable()
                  .size(24)
                  .foregroundColor(theme.colors.border)
                Text(chat.isAdmin ? "Delete" : "Leave")
                  .font(theme.fonts.mini.font)
                  .foregroundColor(theme.colors.border)
              }
            }.size(60)
          }
        }.padding(.horizontal, 8)
          .height(60)
          .background(.thinMaterial)
          .cornerRadius(16)
      }.padding(.horizontal, 16)
    }.confirmationDialog("Are you sure you want to leave this channel?", isPresented: $leave) {
      Button("Leave \(chat.displayName)?", role: .destructive) {
        dismiss()
        chat.leave()
        navigator.goBack()
      }
    }.confirmationDialog("Are you sure you want to delete this channel?", isPresented: $delete) {
      Button("Delete \(chat.displayName)?", role: .destructive) {
        Task.detached {
          do {
            try await chat.delete()
            await MainActor.run {
              self.dismiss()
              navigator.goBack()
            }
          } catch let err {
            Monitoring.error(err)
          }
        }
      }
    }
  }

  func header(_ text: String) -> some View {
    return Text(text)
      .textCase(.uppercase)
      .font(theme.fonts.caption.font.bold())
      .foregroundColor(theme.colors.caption)
      .padding(.top, 24)
  }
}
