import Foundation
import SwiftUI
import Combine
import SDWebImage

public class UIProfile: UIMyProfile {
  
  @IBOutlet var headerImage: SDAnimatedImageView!
  @IBOutlet var blockTitle: UILabel!
  @IBOutlet var status: UIButton!
  @IBOutlet var blockRow: UIView!
  @IBOutlet var messageRow: UIView!
  
  var user: User! {
    didSet {
      bag.forEach {$0.cancel()}
      bag.removeAll()
      user.objectWillChange.makeConnectable().autoconnect()
        .sink { [weak self] _ in
          DispatchQueue.main.async {
            self?.updateUI()
          }
        }.store(in: &bag)
      updateUI()
    }
  }
    
  override func getUser() -> User {
    return user ?? Chats.current.user!
  }
  
  deinit {
    bag.forEach { $0.cancel() }
    bag.removeAll()
  }
  
  @IBAction func block() {
    user.block()
  }
  
  override var isTabController: Bool {
    return false
  }
  
  override func updateUI() {
    super.updateUI()
    let user = getUser()
    self.blockTitle.text = (getUser().blocked ? "Unblock" : "Block") + " \(getUser().username)"
    self.lblTitle.text = getUser().username
    self.blockRow.isHidden = getUser().isCurrent
    self.messageRow.isHidden = self.blockRow.isHidden
    if let img = user.avatar {
      headerImage.sd_setImage(with: img.url)
    } else {
      headerImage.image = AssetImage("user-fill")
    }
    status.setTitle(user.status == .online ? "Online" : user.lastSeen?.timeAgo() ?? "", for: .normal)
    status.setTitleColor((user.status == .online ? c().primary : c().text).ui, for: .normal)
  }
}

public struct Profile: View {

  let id: String
  @State var user: User?
  @Environment(\.iacTheme) var theme
  @Environment(\.geometry) var geometry

  public init(id: String) {
    self.id = id
    _user = State(initialValue: User.get(id))
  }

  public var body: some View {
    ZStack(alignment: .top) {
      ScrollView {
        if let user = user {
          UserProfile(user: user).grow()
        } else {
          SpinnerList()
        }
      }.grow().padding(.top, geometry.insets.top + Header<Image>.height + 20.0)
      Header(title: user?.username ?? "") {
        Avatar(url: user?.avatar)
      }
    }.grow().edgesIgnoringSafeArea(.all)
  }
}

public struct UserProfile: View {
  @ObservedObject var user: User
  @Environment(\.iacTheme) var theme
  @Environment(\.geometry) var geometry

  public var body: some View {
    VStack {
      VStack {
        Avatar(url: user.avatar, size: 150.0)
        Text(user.displayNameFb)
          .foregroundColor(theme.colors.text)
          .font(theme.fonts.headline.font)
        ZStack {
          Text(user.status == .online ? "Online" : user.lastSeen?.timeAgo() ?? "")
            .foregroundColor(user.status == .online ? theme.colors.primary : theme.colors.text)
        }.padding(.horizontal, 12.0)
          .padding(.vertical, 5.0)
          .cornerRadius(30.0)
          .background(theme.colors.softBackground)
      }

      if !user.isCurrent {
        Divider()
          .foregroundColor(theme.colors.softBackground)
        NavLink(to: user.chatPath) {
          Row(icon: "paper-plane-tilt-fill", text: "Send a Chat", iconPrimary: true)
        }
      }
//      HStack {
//        Text("Shared Media")
//          .foregroundColor(theme.colors.text)
//          .font(theme.fonts.body.font)
//        Spacer()
//      }.padding(.top, 8.0)
//        .padding(.leading, 16.0)
//      ScrollView(.horizontal, showsIndicators: false) {
//        LazyHStack {
//          ForEach(user.sharedMedia.items, id: \.id) {
//            message in
//            MessageContent(message: message)
//          }
//        }.padding(.leading, 16.0)
//      }
      Spacer().height(24.0)
      Divider().foregroundColor(theme.colors.caption)
      if !user.isCurrent {
        Button {
          user.block()
        } label: {
          Row(
            icon: user.blocked ? "lock-simple-open-fill" : "lock-fill",
            text: "\(user.blocked ? "Unblock" : "Block") \(user.username)",
            iconPrimary: user.blocked,
            destructive: !user.blocked
          )
        }
      }
    }
      .onChange(of: user.blocked) { newValue in
        print("User blocked ", newValue)
      }
  }
}
