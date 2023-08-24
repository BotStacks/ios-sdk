import Foundation
import SwiftUI
import Combine
import SDWebImage
import PhotosUI

public class UIProfile: UIMyProfile, PHPickerViewControllerDelegate, UITextFieldDelegate {
  
  @IBOutlet var headerImage: SDAnimatedImageView!
  @IBOutlet var blockTitle: UILabel!
  @IBOutlet var status: UIButton!
  @IBOutlet var blockRow: UIView!
  @IBOutlet var messageRow: UIView!
  @IBOutlet var reportRow: UIView!
  
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
    return user ?? InAppChatStore.current.user!
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
    self.reportRow.isHidden = self.blockRow.isHidden
    if let img = user.avatar {
      headerImage.sd_setImage(with: img.url)
    } else {
      headerImage.image = AssetImage("user-fill")
    }
    status.setTitle(user.status == .online ? "Online" : user.lastSeen?.timeAgo() ?? "", for: .normal)
    status.setTitleColor((user.status == .online ? c().primary : c().text).ui, for: .normal)
  }
  
  public override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "chat" {
      let room = segue.destination as? UIChatRoom
      room?.user = user
    } else if segue.identifier == "flag" {
      let room = segue.destination as? UIFlagController
      room?.user = user
      room?.onSubmit = { [weak self] in
        self?.dismiss(animated: true)
        self?.view.makeToast("User reported. Thanks.")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
          self?.navigationController?.popViewController(animated: true)
        }
      }
    }
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
    imageLoader.startAnimating()
    imageLoader.isHidden = false
    imageLoader.color = c().primary.ui
    let identifier = [UTType.image.identifier]
    print("picker did finsih picking", results)
    if let result = results.first,
       let match = identifier.first(where: {
         result.itemProvider.hasItemConformingToTypeIdentifier($0)
       })
    {
      print("Getting file for ", match)
      let progress = result.itemProvider.loadFileRepresentation(forTypeIdentifier: match) {
        url, err in
        if let err = err {
          print("Error Loading File", err)
        } else if let url = url {
          do {
            let tmp = try tmpFile()
            print("Copy from url", url.absoluteString, "to", tmp.absoluteString)
            try FileManager.default.copyItem(
              at: url, to: tmp)
            Task.detached {
              do {
                let url = try await api.uploadFile(file: .init(url: tmp))
                let res = try await api.updateProfile(input: .init(image: .some(url)))
                await MainActor.run {
                  User.current?.avatar = url
                  self.imageLoader.stopAnimating()
                  self.view.makeToast("Profile picture updated")
                }
              } catch let err {
                Monitoring.error(err)
                DispatchQueue.main.async {
                  self.view.makeToast("Image upload failed. Please try again.")
                }
              }
            }
          } catch let err {
            print("Failed to copy file", err)
          }
        }
      }
    } else {
      print("No picker results")
    }
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
