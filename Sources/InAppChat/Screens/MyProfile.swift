import Foundation
import SwiftUI
import UIKit
import Combine
import SDWebImage

public class UIBaseController: UIViewController {
  @IBOutlet var lblTitle: UILabel!
  @IBOutlet var btnBack: UIButton!
  
  var isTabController: Bool {
    return false
  }
  
  override public func viewDidLoad() {
    lblTitle.font = Theme.current.fonts.title.bold
    if isTabController && InAppChat.shared.hideBackButton {
      btnBack.snp.updateConstraints { make in
        make.width.equalTo(0)
      }
      btnBack.layer.opacity = 0
      self.lblTitle.snp.updateConstraints { make in
        make.left.equalToSuperview().inset(24.0)
      }
    }
  }
  
  @IBAction func back() {
    self.navigationController?.popViewController(animated: true)
  }
}


public class UIMyProfile: UIBaseController {
  
  @IBOutlet var displayName: UILabel!
  @IBOutlet var image: SDAnimatedImageView!
  
  var bag = Set<AnyCancellable>()
  
  override var isTabController: Bool {
    return true
  }
  
  override public func viewDidLoad() {
    super.viewDidLoad()
    getUser().objectWillChange.makeConnectable().autoconnect().sink { [weak self] _ in
      DispatchQueue.main.async {
        self?.updateUI()
      }
    }.store(in: &bag)
    updateUI()
  }
  
  func getUser() -> User {
    return InAppChatStore.current.user!
  }
    
  deinit {
    bag.forEach { $0.cancel() }
    bag.removeAll()
  }
  
  func updateUI() {
    let _ = self.view
    let user = getUser()
    if let image = user.avatar {
      self.image.sd_setImage(with: image.url)
    } else {
      image.image = AssetImage("user-fill")
    }
    displayName.text = user.displayNameFb
  }
  
  @IBAction func logout() {
    let alert = UIAlertController(title: "Logout", message: "Are you sure you want to logout?", preferredStyle: .alert)
    alert.addAction(
      .init(title: "No", style: .cancel)
    )
    alert.addAction(
      .init(title: "Yes", style: .destructive, handler: { _ in
        InAppChat.logout()
        self.navigationController?.popViewController(animated: true)
      }
           )
    )
    self.present(alert, animated: true)
  }
}

public struct MyProfile: View {

  @Environment(\.iacTheme) var theme
  let onBack: (() -> Void)?
  @Environment(\.geometry) var geometry

  @State var logout = false

  public init(onBack: (() -> Void)? = nil) {
    self.onBack = onBack
  }

  public var body: some View {
    ScrollView {
      Header(title: "My Profile", showStartMessage: false, showSearch: false, onBack: onBack)
      VStack(alignment: .center) {
        Avatar(url: User.current?.avatar, size: 150.0)
        Text(
          .init(User.current?.displayNameFb ?? "")
        )
        .foregroundColor(theme.colors.text)
        .frame(maxWidth: 150.0)
        .truncationMode(.middle)
        .multilineTextAlignment(.center)
      }
      NavLink(to: User.current!.path) {
        Row(icon: "user-fill", text: "Profile")
      }
      NavLink(to: "/favorites") {
        Row(icon: "star-fill", text: "Favorite Messages")
      }
      NavLink(to: "/settings/notifications") {
        Row(
          icon: "bell-simple-fill", text: "Manage Notifications"
        )
      }
      Row(icon: "door-fill", text: "Logout")
        .onTapGesture {
          logout = true
        }
      Spacer()
    }.edgesIgnoringSafeArea(.all)
      .alert("Are you sure you want to log out?", isPresented: $logout) {
        Button {
          logout = false
        } label: {
          Text("Cancel")
            .foregroundColor(theme.colors.caption)
            .font(theme.fonts.headline.font)
        }

        Button {
          InAppChat.logout()
        } label: {
          Text("Log Out")
            .foregroundColor(theme.colors.primary)
            .font(theme.fonts.headline.font)
        }
      }.padding(.bottom, 70.0 + geometry.insets.bottom)
  }
}
