import Foundation
import SwiftUI
import UIKit
import Combine
import SDWebImage
import PhotosUI

public class UIBaseController: UIViewController {
  @IBOutlet var lblTitle: UILabel!
  @IBOutlet var btnBack: UIButton!
  
  var isTabController: Bool {
    return false
  }
  
  override public func viewDidLoad() {
    lblTitle.font = Theme.current.fonts.title.bold
    if isTabController && BotStacksChat.shared.hideBackButton {
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
  
  @IBAction func more() {
    let controller = UIAlertController(title: "Delete account?", message: "You can delete your account. All your profile information will be deleted. This action is permanent", preferredStyle: .alert)
    controller.addAction(.init(title: "No thanks", style: .cancel))
    controller.addAction(.init(title: "Delete My Account", style: .destructive, handler: { _ in
      Task.detached {
        await api.deleteAccount()
      }
    }))
    self.present(controller, animated: true)
  }
}


public class UIMyProfile: UIBaseController, PHPickerViewControllerDelegate, UITextFieldDelegate {
  
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
    return BotStacksChatStore.current.user!
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
        BotStacksChat.logout()
        self.navigationController?.popViewController(animated: true)
      }
           )
    )
    self.present(alert, animated: true)
  }
  
  @IBOutlet var imageLoader: UIActivityIndicatorView!
  @IBAction func tapProfile() {
    if getUser().isCurrent {
      var config = PHPickerConfiguration(photoLibrary: .shared())
      config.filter = .images
      config.preferredAssetRepresentationMode = .current
      let picker = PHPickerViewController(configuration: config)
      picker.delegate = self
      self.present(picker, animated: true)
    }
  }
  
  @IBAction func tapUsername() {
    if getUser().isCurrent {
      let alert = UIAlertController(title: "Change Nickname", message: "Input a new nickname if you'd like to change it", preferredStyle: .alert)
      alert.addTextField { field in
        field.delegate = self
      }
      let cancel = UIAlertAction(title: "Cancel", style: .cancel)
      alert.addAction(cancel)
      let submitAction = UIAlertAction(title: "Submit", style: .default) { [unowned alert] _ in
        let answer = alert.textFields![0]
        if let text = answer.text, text.count >= 5 {
          let original = User.current?.displayName
          User.current?.displayName = text
          Task.detached {
            do {
              let res = try await api.updateProfile(input: .init(display_name: .some(text)))
              await MainActor.run {
                self.view.makeToast("Nickname updated")
              }
            } catch let err {
              Monitoring.error(err)
              await MainActor.run {
                User.current?.displayName = original
                self.view.makeToast("Failed to update nickname. Please try again")
              }
            }
          }
        } else {
          self.view.makeToast("Nickname must 5 or more characters")
        }
        
      }
      
      alert.addAction(submitAction)
      
      present(alert, animated: true)
    }
  }
  
  
  
  public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
    if CharacterSet.alphanumerics.isSuperset(of: CharacterSet(charactersIn: string)) || string == "_" {
      return true
    }
    return false
  }
  
  public func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
    self.dismiss(animated: true)
    if let result = results.first
    {
      imageLoader.startAnimating()
      imageLoader.isHidden = false
      imageLoader.color = c().primary.ui
      result.file { tmp in
        Task.detached {
          do {
            let url = try await api.uploadFile(file: .init(url: tmp))
            let _ = try await api.updateProfile(input: .init(image: .some(url)))
            await MainActor.run {
              User.current?.avatar = url
              self.imageLoader.stopAnimating()
              self.imageLoader.isHidden = true
              self.view.makeToast("Profile picture updated")
            }
          } catch let err {
            Monitoring.error(err)
            print("Error \(err)")
            DispatchQueue.main.async {
              self.imageLoader.stopAnimating()
              self.imageLoader.isHidden = true
              self.view.makeToast("Image upload failed. Please try again.")
            }
          }
        }
      }
    } else {
      print("No picker results")
    }
  }
}

public extension PHPickerResult {
  func file(_ cb: @escaping (URL) -> Void) {
    let identifiers = [UTType.gif.identifier, UTType.image.identifier]
    guard let match = identifiers.first(where: {itemProvider.hasItemConformingToTypeIdentifier($0)}) else {
      return
    }
    let isGif = itemProvider.hasItemConformingToTypeIdentifier(UTType.gif.identifier)
    itemProvider.loadFileRepresentation(forTypeIdentifier: match) {
      url, err in
      if let err = err {
        print("Error Loading File", err)
      } else if let url = url {
        do {
          let tmp = try tmpFile(ext: isGif ? "gif" : "png")
          print("Copy from url", url.absoluteString, "to", tmp.absoluteString)
          if isGif {
            try FileManager.default.copyItem(at: url, to: tmp)
          } else {
            try UIImage(data: try Data(contentsOf: url))?.png(isOpaque: false)?.write(to: tmp)
          }
          cb(tmp)
        } catch let err {
          print("Failed to copy file", err)
        }
      }
    }
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
          BotStacksChat.logout()
        } label: {
          Text("Log Out")
            .foregroundColor(theme.colors.primary)
            .font(theme.fonts.headline.font)
        }
      }.padding(.bottom, 70.0 + geometry.insets.bottom)
  }
}
