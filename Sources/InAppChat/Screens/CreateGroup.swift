//
//  Createchat.swift
//  InAppChat
//
//  Created by Zaid Daghestani on 2/9/23.
//

import Foundation
import SwiftUI
import SDWebImage
import Combine
import PhotosUI


class CreateChatState: ObservableObject {

  @Published var chat: Chat? = nil
  @Published var image: URL? = nil
  @Published var name: String = ""
  @Published var description: String = ""
  @Published var _private = false
  @Published var members: [Member] = []

  func apply(_ chat: Chat) {
    self.chat = chat
    self.image = chat.displayImage.flatMap({ URL(string: $0) })
    self.name = chat.displayName
    self.description = chat.description ?? ""
    self._private = chat._private
    self.members = chat.members
  }

  func commit() async {
    do {
      try await self.chat?.update(
      name: name != chat?.name ? name : nil,
      description: chat?.description != description ? description : nil,
      image: chat?.image != image?.absoluteString ? image : nil,
      _private: chat?._private != _private ? _private : nil
    )
    } catch {
      
    }
  }

  static var current: CreateChatState? = nil

  static func currentOrNew() -> CreateChatState {
    if current == nil {
      current = CreateChatState()
    }
    return current!
  }
}

public class UICreateChat: UIBaseController, UITextFieldDelegate, UITextViewDelegate, PHPickerViewControllerDelegate {
  
  @IBOutlet var addImage: UIImageView!
  @IBOutlet var image: SDAnimatedImageView!
  @IBOutlet var lblChannel: UILabel!
  @IBOutlet var lblChannelCount: UILabel!
  @IBOutlet var contChannel: UIView!
  @IBOutlet var txtChannel: UITextField!
  @IBOutlet var lblChannelError: UILabel!
  @IBOutlet var lblDesc: UILabel!
  @IBOutlet var lblDescCount: UILabel!
  @IBOutlet var contDesc: UIView!
  @IBOutlet var lblDescPlaceholder: UILabel!
  @IBOutlet var txtDesc: UITextView!
  @IBOutlet var lblPrivacy: UILabel!
  @IBOutlet var contPrivacy: UIView!
  @IBOutlet var pillPublic: UIView!
  @IBOutlet var pillLblPublic: UILabel!
  @IBOutlet var pillPrivate: UIView!
  @IBOutlet var pillLblPrivate: UILabel!
  @IBOutlet var lblPrivacyDescription: UILabel!
  @IBOutlet var btnNext: UIButton!
  @IBOutlet var imageIndicator: UIActivityIndicatorView!
  @IBOutlet var nextIndicator: UIActivityIndicatorView!
  @IBOutlet var btnSave: UIButton!
  @IBOutlet var scrollview: UIScrollView!
  @IBOutlet var spacerHeight: NSLayoutConstraint!
  @IBOutlet var scrollviewBottom: NSLayoutConstraint!
  
  var chat: Chat? {
    didSet {
      if viewIfLoaded != nil {
        self.bindUI()
      }
    }
  }
    
  override public func viewDidLoad() {
    super.viewDidLoad()
    let t = Theme.current
    let c = t.colors
    let f = t.fonts
    addImage.tintColor = c.softBackground.ui
    lblChannel.textColor = c.text.ui
    lblChannel.font = f.headline
    lblChannelCount.font = f.headline
    lblChannelCount.textColor = c.caption.ui
    contChannel.backgroundColor = c.softBackground.ui
    contChannel.layer.borderColor = c.border.cgColor
    txtChannel.font = f.headline
    lblDesc.textColor = c.text.ui
    lblDesc.font = f.headline
    lblDescCount.font = f.headline
    lblDescCount.textColor = c.caption.ui
    contDesc.backgroundColor = c.softBackground.ui
    contDesc.layer.borderColor = c.border.cgColor
    lblDescPlaceholder.font = f.headline
    lblDescPlaceholder.textColor = c.caption.ui
    txtDesc.font = f.headline
    txtDesc.textColor = c.text.ui
    lblPrivacy.font = f.headline
    lblPrivacy.textColor = c.text.ui
    contPrivacy.backgroundColor = c.softBackground.ui
    contPrivacy.layer.borderColor = c.border.cgColor
    pillPublic.backgroundColor = c.primary.ui
    pillPrivate.backgroundColor = .clear
    pillLblPublic.font = f.headline
    pillLblPrivate.font = f.headline
    pillLblPublic.textColor = c.background.ui
    pillLblPrivate.textColor = c.text.ui
    lblPrivacyDescription.font = f.caption
    lblPrivacyDescription.textColor = c.text.ui
    nextIndicator.color = c.text.ui
    imageIndicator.color = .white
    nextIndicator.isHidden = true
    lblChannelError.isHidden = true
    btnSave.setAttributedTitle(.init(string: "Save", attributes: [.font: f.headline]), for: .normal)
    bindUI()
    let notificationCenter = NotificationCenter.default
    notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
    notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillShowNotification, object: nil)
  }
  
  
  var img: URL? {
    didSet {
      if let image = img {
        self.image.sd_setImage(with: image)
        print("Edit group set image \(image)")
        self.image.isHidden = false
        self.addImage.isHidden = true
      } else {
        print("Edit group set image none")
        self.image.isHidden = true
        self.addImage.isHidden = false
      }
    }
  }
  var _private = false {
    didSet {
      if _private {
        pillPublic.backgroundColor = .clear
        pillPrivate.backgroundColor = c().primary.ui
        pillLblPublic.textColor = c().text.ui
        pillLblPrivate.textColor = c().background.ui
        lblPrivacyDescription.text = "Private channels will not be seen by anyone unless they invited to join the channel."
      } else {
        pillPrivate.backgroundColor = .clear
        pillPublic.backgroundColor = c().primary.ui
        pillLblPrivate.textColor = c().text.ui
        pillLblPublic.textColor = c().background.ui
        lblPrivacyDescription.text = "Public channels will be viewed by all and available for everyone to join."
      }
    }
  }
  
  @objc func adjustForKeyboard(notification: Notification) {
    guard let userInfo = notification.userInfo,
          let animationDurationNumber = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber,
          let animationCurveNumber = userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? NSNumber,
          let keyboardFrameBeginValue = userInfo[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue,
          let keyboardFrameEndValue = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue
    else {
      print("Skip keyboard adjust")
      return
    }
    let keyboardFrameEnd = keyboardFrameEndValue.cgRectValue
    let show = notification.name == UIResponder.keyboardWillShowNotification
    let height =  show ?  keyboardFrameEnd.height : 0.0
    spacerHeight.constant = height
    scrollview.contentInset = .init(top: 0, left: 0, bottom: height, right: 0)
    scrollview.layoutIfNeeded()
    let newY = height
    scrollview.setContentOffset(.init(x: 0, y: newY), animated: true)
//    scrollviewBottom.constant = notification.name == UIResponder.keyboardWillShowNotification ?  keyboardFrameEnd.height : 0.0
//    UIView.animate(withDuration: animationDuration, delay: 0.0, options: animationCurveOptions) {
//      self.view.layoutIfNeeded()
//    }
  }
  
  func bindUI() {
    if let chat = chat {
      img = chat.displayImage?.url
      _private = chat._private
      txtChannel.text = chat.displayName
      
      txtDesc.text = chat.description
      btnSave.isHidden = false
      btnNext.isHidden = true
      
    } else {
      btnSave.isHidden = true
      btnNext.isHidden = false
    }
    updateChannel()
    updateDesc()
  }
  
  @IBAction func tapBG() {
    txtDesc.resignFirstResponder()
    txtChannel.resignFirstResponder()
  }
  
  func updateChannel() {
    let txt = txtChannel.text ?? ""
    lblChannelCount.text = "\(txt.count)/25"
    if txt.count > 25 {
      lblChannelCount.textColor = .red
    } else {
      lblChannelCount.textColor = c().caption.ui
    }
    updateNext()
  }
  
  func updateNext() {
    let name = txtChannel.text ?? ""
    if name.count >= 3 {
      btnNext.tintColor = c().primary.ui
      btnSave.tintColor = c().primary.ui
    } else {
      btnNext.tintColor = c().caption.ui
      btnSave.tintColor = c().caption.ui
    }
  }
  
  public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
    if string == "\n" {
      txtDesc.becomeFirstResponder()
      return false
    }
    DispatchQueue.main.async {
      self.updateChannel()
    }
    self.lblChannelError.isHidden = true
    return true
  }
  
  func updateDesc() {
    let d = txtDesc.text ?? ""
    lblDescCount.text = "\(d.count)/100"
    if d.count > 100 {
      lblDescCount.textColor = .red
    } else {
      lblDescCount.textColor = c().caption.ui
    }
    print("Text Description \(d.count) '\(d)'")
    if d.isEmpty && !txtDesc.isFirstResponder {
      lblDescPlaceholder.isHidden = false
    } else {
      lblDescPlaceholder.isHidden = true
    }
  }
  
  public func textViewDidBeginEditing(_ textView: UITextView) {
    lblDescPlaceholder.isHidden = true
  }
  
  public func textViewDidEndEditing(_ textView: UITextView) {
    updateDesc()
  }
  
  public func textViewDidChange(_ textView: UITextView) {
    self.updateDesc()
  }
  
  var isShift = false
  public override func pressesBegan(_ presses: Set<UIPress>, with event: UIPressesEvent?) {
    guard let key = presses.first?.key else { return }
    switch key.keyCode {
    case .keyboardReturn:
      if key.modifierFlags == .shift {
        isShift = true
      } else {
        isShift = false
      }
      super.pressesBegan(presses, with: event)
      break
    default:
      super.pressesBegan(presses, with: event)
    }
  }
  
  public func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
    if text == "\n" && !isShift {
      textView.resignFirstResponder()
      return false
    }
    return true
  }
  
  
  @IBAction func tapPublic() {
    _private = false
    tapBG()
  }
  
  @IBAction func tapPrivate() {
    _private = true
    tapBG()
  }
  
  @IBAction func tapImage() {
    print("Tap Image")
    var config = PHPickerConfiguration(photoLibrary: .shared())
    config.filter = .images
    config.preferredAssetRepresentationMode = .current
    let picker = PHPickerViewController(configuration: config)
    picker.delegate = self
    self.present(picker, animated: true)
  }
  
  var loading = false
  
  @IBAction func next() {
    tapBG()
    if loading {return}
    loading = true
    let name = txtChannel.text ?? ""
    if name.count < 3 {
      self.lblChannelError.isHidden = false
      return
    }
    if loadingImage {
      nextOnUpload = true
      self.nextIndicator.startAnimating()
      self.nextIndicator.isHidden = false
      return
    }
    if let chat = chat {
      self.nextIndicator.startAnimating()
      self.nextIndicator.isHidden = false
      let name = self.txtChannel.text ?? ""
      let description = self.txtDesc.text ?? ""
      let image = self.uploadedImageUrl
      let _private = self._private
      Task.detached {
        do {
          try await chat.update( name: name != chat.name ? name : nil,
                                 description: chat.description != description ? description : nil,
                                 image: chat.image != image?.absoluteString ? image : nil,
                                 _private: chat._private != _private ? _private : nil)
          DispatchQueue.main.async {
            self.onUpdate()
          }
        } catch {
          DispatchQueue.main.async {
            self.onUpdateFailed()
          }
        }
      }
    } else {
      self.performSegue(withIdentifier: "invite", sender: nil)
    }
  }
  
  func onUpdate() {
    self.navigationController?.popViewController(animated: true)
  }
  
  func onUpdateFailed() {
    self.view.makeToast("Failed to update Chat. Try again or contact support if the issue persists.")
    loading = false
    self.nextIndicator.stopAnimating()
    self.nextIndicator.isHidden = true
  }
  
  var loadingImage = false
  var uploadedImageUrl: URL? = nil
  var nextOnUpload = false
  
  func onImageFile(_ tmp: URL) {
    loadingImage = true
    self.imageIndicator.startAnimating()
    self.imageIndicator.isHidden = false
    self.image.sd_setImage(with: tmp)
    print("Loading Image")
    Task.detached {
      do {
        print("Uploading image")
        let url = try await api.uploadFile(file:.init(url: tmp))
        DispatchQueue.main.async {
          print("IMage uploaded to \(url)")
          if let url = url.url {
            self.onUpload(url)
          }
        }
      } catch let err {
        Monitoring.error(err)
        print(err)
        DispatchQueue.main.async {
          self.onUploadError()
        }
      }
    }
  }
  
  func onUpload(_ url: URL) {
    self.uploadedImageUrl = url
    self.loadingImage = false
    self.image.sd_setImage(with: url)
    self.image.isHidden = false
    self.imageIndicator.stopAnimating()
    if nextOnUpload {
      next()
    }
  }
  
  func onUploadError() {
    self.view.makeToast("The image failed to upload. Try again or skip adding one for now")
  }
  
  public func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
    self.dismiss(animated: true)
    let identifier =  [UTType.image.identifier]
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
            DispatchQueue.main.async {
              self.onImageFile(tmp)
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
  
  override public func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "invite" {
      let invite = segue.destination as! UIInviteUsers
      invite.create = (uploadedImageUrl, txtChannel.text ?? "", txtDesc.text, _private)
    }
  }
}

public struct CreateChat: View {

  @Environment(\.iacTheme) var theme
  @EnvironmentObject var navigator: Navigator
  @Environment(\.geometry) var geometry

  enum Field: Hashable {
    case name
    case description
  }

  @FocusState private var focus: Field?

  @ObservedObject var state = CreateChatState.currentOrNew()
  @State var pickImage = false

  public init(_ chatID: String? = nil) {
    if let chatID = chatID, let chat = Chat.get(chatID) {
      state.apply(chat)
    }
  }

  var canGoNext: Bool {
    return state.name.count >= 3 && state.name.count <= 25 && state.description.count <= 100
  }

  public var body: some View {
    VStack(alignment: .leading, spacing: .none) {
      Header(
        title: "Create Channel",
        onBack: {
          navigator.goBack()
          CreateChatState.current = nil
        })
      ScrollView {
        VStack {
          VStack {
            Button {
              pickImage = true
            } label: {
              if let image = state.image {
                GifImageView(url: image)
                  .circle(116, theme.colors.softBackground)
              } else {
                AssetImage("plus-circle-fill")
                  .image
                  .resizable()
                  .foregroundColor(theme.colors.softBackground)
                  .size(95)
              }
            }
          }
          VStack {
            VStack {
              HStack {
                Text("Channel Name")
                  .font(theme.fonts.headline.font)
                  .foregroundColor(theme.colors.text)
                Spacer()
                Text("\(state.name.count)/25")
                  .font(theme.fonts.headline.font)
                  .foregroundColor(
                    theme.colors.caption
                  )
              }
              HStack {
                TextField(
                  text: $state.name,
                  prompt: Text("Type here").font(theme.fonts.headline.font)
                    .foregroundColor(
                      theme.colors.caption),
                  label: {}
                )
                .background(.clear)
                .font(theme.fonts.headline.font)
                .foregroundColor(theme.colors.text)
                .onChange(of: state.name) {
                  state.name = String($0.prefix(25))
                }.focused($focus, equals: .name)
              }.growX()
                .padding(.horizontal, 20)
                .height(50)
                .background(theme.colors.softBackground)
                .cornerRadius(25)
                .overlay(
                  RoundedRectangle(cornerRadius: 25).stroke(theme.colors.border, lineWidth: 1)
                )
                .onTapGesture {
                  focus = .name
                }
            }
            VStack {
              HStack {
                Text("Description (Optional)")
                  .font(theme.fonts.headline.font)
                  .foregroundColor(theme.colors.text)
                Spacer()
                Text("\(state.description.count)/100")
                  .font(theme.fonts.headline.font)
                  .foregroundColor(
                    theme.colors.caption
                  )
              }
              ZStack(alignment: .topLeading) {
                let e = TextEditor(text: $state.description)
                  .background(.clear)
                  .grow()
                  .font(theme.fonts.headline.font)
                  .foregroundColor(theme.colors.text)
                  .focused($focus, equals: .description)
                  .onChange(
                    of: state.description,
                    perform: { newValue in
                      state.description = String(newValue.prefix(100))
                    })
                if #available(iOS 16.0, *) {
                  e.scrollContentBackground(.hidden)
                } else {
                  e.onAppear {
                    UITextView.appearance().backgroundColor = .clear
                  }
                }

                if state.description.isEmpty && focus != .description {
                  Text("Showcase what your channel is all about for everyone to see").font(
                    theme.fonts.headline.font
                  ).foregroundColor(theme.colors.caption)
                }
              }.growX()
                .padding(.horizontal, 20)
                .padding(.vertical, 12)
                .height(128)
                .background(theme.colors.softBackground)
                .cornerRadius(25)
                .overlay(
                  RoundedRectangle(cornerRadius: 25).stroke(theme.colors.border, lineWidth: 1)
                )
                .onTapGesture {
                  focus = .description
                }
            }
            VStack(alignment: .leading) {
              Text("Privacy Setting")
                .font(theme.fonts.headline.font)
                .foregroundColor(theme.colors.text)
                .padding(.leading, 8)
              ZStack {
                HStack {
                  if state._private {
                    Spacer()
                  }
                  Capsule()
                    .fill(theme.colors.primary)
                    .frame(width: (geometry.width - 32.0) / 2.0, height: 50)
                  if !state._private {
                    Spacer()
                  }
                }
                HStack {
                  Button {
                    state._private = false
                  } label: {
                    ZStack {
                      Text("Public")
                        .font(theme.fonts.title3.font)
                        .foregroundColor(
                          state._private ? theme.colors.text : theme.colors.background
                        )
                    }.grow()
                  }
                  Button {
                    state._private = true
                  } label: {
                    ZStack {
                      Text("Private")
                        .font(theme.fonts.title3.font)
                        .foregroundColor(
                          !state._private ? theme.colors.text : theme.colors.background)
                    }.grow()
                  }
                }.grow()
              }.growX()
                .overlay(
                  RoundedRectangle(cornerRadius: 25).stroke(theme.colors.border, lineWidth: 1)
                )
                .height(50)
                .background(theme.colors.softBackground)
                .cornerRadius(25)
              Text(
                state._private
                  ? "Public channels will be viewed by all and available for everyone to join."
                  : "Private channels will not be seen by anyone unless they are invited to join the channel."
              )
              .font(theme.fonts.caption.font)
              .foregroundColor(theme.colors.text)
            }
            Spacer()
            HStack {
              Spacer()
              Button {
                if canGoNext {
                  if state.chat != nil {
                    Task.detached {
                      await state.commit()
                      await MainActor.run {
                        navigator.goBack()
                      }
                    }
                  } else {
                    navigator.navigate(state.chat?.invitePath ?? "/group/new/invite")
                  }
                }
              } label: {
                if state.chat != nil {
                  VStack {
                    HStack {
                      if state.chat?.updating == true {
                        Spinner().size(35)
                          .foregroundColor(theme.colors.background)
                      }
                      Text("Save")
                        .font(theme.fonts.headline.font)
                        .foregroundColor(theme.colors.text)
                    }
                  }.growX()
                    .height(50)
                    .background(canGoNext ? theme.colors.primary : theme.colors.caption)
                    .cornerRadius(25)
                } else {
                  ZStack {
                    Image(systemName: "chevron.right")
                      .resizable()
                      .scaledToFit()
                      .size(20)
                      .tint(theme.colors.background)
                  }.circle(50, canGoNext ? theme.colors.primary : theme.colors.caption)
                }
              }
            }
          }.padding(.horizontal, 16.0)
        }
        .padding(.bottom, geometry.insets.bottom + 12.0)
        .padding(.top, 12.0)
        .frame(minHeight: geometry.height - geometry.insets.top - Header<EmptyView>.height)
      }
    }.grow()
      .background(theme.colors.background)
      .sheet(isPresented: $pickImage) {
        PhotoPicker(video: false, onProgress: { $0.resume() }) {
          self.state.image = $0
        }
      }
  }
}
