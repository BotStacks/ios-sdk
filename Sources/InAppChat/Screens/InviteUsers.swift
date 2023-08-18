//
//  InviteUsers.swift
//  InAppChat
//
//  Created by Zaid Daghestani on 2/9/23.
//

import Foundation
import SwiftUI
import Combine

public class UIInviteUsers: UIBaseController, UITableViewDelegate, UITableViewDataSource {
  
  var chat: Chat?
  var create: (URL?, String, String?, Bool)?
  
  @IBOutlet var tableView: UITableView!
  @IBOutlet var btnBackBottom: UIButton!
  @IBOutlet var btnSubmit: UIButton!
  @IBOutlet var activityIndicator: UIActivityIndicatorView!
  
  func loadUsers() -> [User] {
    var users = Chats.current.contacts.items
    if let chat = chat {
      let m = Set<String>(chat.members.map({$0.user_id}))
      return users.filter({!m.contains($0.id)})
    }
    return users
  }

  
  var users: [User] = [] {
    didSet {
      tableView?.reloadData()
    }
  }
  
  var bag = Set<AnyCancellable>()
  
  public override func viewDidLoad() {
    super.viewDidLoad()
    btnBackBottom.tintColor = Theme.current.inverted.softBackground.ui
//    btnBackBottom.titleLabel?.textColor = Theme.current.inverted.text.ui
    btnSubmit.tintColor = Theme.current.colors.primary.ui
    btnSubmit.setTitle(chat != nil ? "Send Invites" : "Create My Channel", for: .normal)
    btnSubmit.titleLabel?.font = Theme.current.fonts.headline
    btnSubmit.setTitleColor(c().background.ui, for: .normal)
    
    Chats.current.contacts.objectWillChange.makeConnectable()
      .autoconnect()
      .sink { [weak self] _ in
        DispatchQueue.main.async {
          self?.tableView?.reloadData()
        }
      }.store(in: &bag)
    activityIndicator.isHidden = true
    activityIndicator.stopAnimating()
    users = loadUsers()
  }
  
  public override func viewDidDisappear(_ animated: Bool) {
    bag.forEach({$0.cancel()})
    bag.removeAll()
  }
  
  var selected = [User]()
  
  public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return users.count
  }
  
  public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "user") as! UIContactRow
    cell.user = users[indexPath.row]
    cell.select?.isHidden = cell.user.isCurrent
    cell.setSelect(selected.contains(cell.user))
    return cell
  }
  
  public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let uid = users[indexPath.row]
    if uid.isCurrent { return }
    if selected.contains(uid) {
      selected.remove(element:uid)
    } else {
      selected.append(uid)
    }
    tableView.reloadRows(at: [indexPath], with: .automatic)
  }
  
  public func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    let user = users[indexPath.row]
    Chats.current.contacts.loadMoreIfNeeded(user)
  }
  
  var creating = false
  
  @IBAction func submit() {
    if selected.isEmpty || creating {return}
    creating = true
    activityIndicator.isHidden = false
    activityIndicator.startAnimating()
    if let chat = chat {
      chat.invite(users: selected)
      self.navigationController?.popViewController(animated: true)
    } else if !creating, let state = create {
      print("Creating new chat")
      self.creating = true
      Task.detached {
        print("Create chat task started")
        do {
          let chat = try await api.createChat(
            name: state.1,
            description: state.2,
            image: state.0,
            private: state.3,
            invites: self.selected.map(\.id)
          )
          await MainActor.run {
            CreateChatState.current = nil
            self.navigationController?.popViewController(animated: false)
            self.navigationController?.popViewController(animated: true)
            let room = UIChatRoom.instance()
            room.chat = chat
            self.navigationController?.pushViewController(room, animated: true)
          }
        } catch let err {
          print("Error creating chat \(err)")
          Monitoring.error(err)
          await MainActor.run {
            self.creating = false
          }
        }
      }
    }
  }
}

public struct InviteUsers: View {

  @ObservedObject var chats = Chats.current
  @Environment(\.geometry) var geometry
  @Environment(\.iacTheme) var theme
  @EnvironmentObject var navigator: Navigator

  let chat: Chat?
  let state = CreateChatState.current

  @State var selected: [User] = []
  @State var creating = false

  public init(chatID: String? = nil) {
    self.chat = chatID.flatMap({ Chat.get($0) })
  }

  public var body: some View {
    ZStack(alignment: .topLeading) {
      VStack {
        PagerList(
          pager: chats.contacts,
          topInset: geometry.insets.top + Header<EmptyView>.height
        ) { contact in
          Button {
            if selected.contains(contact) {
              selected.remove(element: contact)
            } else {
              selected.append(contact)
            }
          } label: {
            HStack {
              ContactRow(user: contact)
              ZStack {
                Image(systemName: "checkmark")
                  .resizable()
                  .scaledToFit()
                  .tint(theme.colors.background)
                  .size(14)
              }.circle(25, selected.contains(contact) ? theme.colors.primary : theme.colors.caption)
            }.padding(.trailing, 16)
          }
        }.height(geometry.height - geometry.insets.bottom - 60.0)
        HStack(spacing: 22.0) {
          Button {
            navigator.goBack()
          } label: {
            ZStack {
              Image(systemName: "chevron.left")
                .resizable()
                .scaledToFit()
                .size(20)
                .tint(theme.colors.background)

            }.circle(50, theme.inverted.softBackground)
          }
          Button {
            print("On Create Chat \(state?.name) \(creating)")
            if let chat = chat {
              chat.invite(users: selected)
              navigator.goBack()
            } else if !creating, let state = state {
              print("Creating new chat")
              self.creating = true
              Task.detached {
                print("Create chat task started")
                do {
                  let chat = try await api.createChat(
                    name: state.name,
                    description: state.description,
                    image: state.image,
                    private: state._private ,
                    invites: self.selected.map(\.id)
                  )
                  await MainActor.run {
                    CreateChatState.current = nil
                    navigator.goBack(total: 2)
                    navigator.navigate(chat.path)
                  }
                } catch let err {
                  print("Error creating chat \(err)")
                  Monitoring.error(err)
                  await MainActor.run {
                    creating = false
                  }
                }
              }
            }
          } label: {
            ZStack {
              HStack {
                if chat?.inviting == true || creating {
                  Spinner()
                    .size(30)
                    .foregroundColor(.white)
                }
                Text(chat != nil ? "Send Invites" : "Create My Channel")
                  .font(theme.fonts.headline.font)
                  .foregroundColor(theme.colors.background)
              }
            }
            .growX()
            .height(50)
            .background(theme.colors.primary)
            .cornerRadius(25)
          }
        }.padding(.horizontal, 16.0)
      }.padding(.bottom, geometry.insets.bottom + 12.0)
      Header(title: "Invite Users")
    }.onAppear {
      print("Render invite users with geometry", geometry)
    }
  }
}
