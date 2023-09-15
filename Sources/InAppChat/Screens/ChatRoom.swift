//
//  ChatRoom.swift
//  InAppChat
//
//  Created by Zaid Daghestani on 2/2/23.
//

import Foundation
import SwiftUI
import UIKit
import SDWebImage
import Combine
import Photos
import PhotosUI
import ContactsUI
import GiphyUISDK

public class UIChatRoom: UIViewController, UITextViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, PHPickerViewControllerDelegate, CNContactPickerDelegate, UIDocumentPickerDelegate, GiphyDelegate, EmojiViewDelegate  {
  
  var bag = Set<AnyCancellable>()
  
  var chat: Chat? {
    didSet {
      if let chat = chat {
        chat.objectWillChange.makeConnectable().autoconnect()
          .sink(receiveValue: { [weak self] _ in
            DispatchQueue.main.async {
              if self?.viewIfLoaded != nil {
                self?.bind(chat: chat)
              }
            }
          }).store(in: &bag)
        if self.viewIfLoaded != nil {
          self.bind(chat: chat)
        }
        messages?.chat = chat
      }
    }
  }
  
  var user: User? {
    didSet {
      if let user = user {
        if let chat = Chat.get(uid: user.id) {
          self.chat = chat
        } else {
          Task.detached {
            do {
              let chat = try await api.dm(user: user.id)
              await MainActor.run {
                self.chat = chat
              }
            } catch let err {
              Monitoring.error(err)
              await MainActor.run {
                self.notFound()
              }
            }
          }
        }
      }
    }
  }
  
  @IBOutlet var groupCount: UILabel!
  @IBOutlet var lblTitle: UILabel!
  @IBOutlet var btnBack: UIButton!
  @IBOutlet var headerImage: SDAnimatedImageView!
  @IBOutlet var groupPlaceholder: UIGroupPlaceholder!
  @IBOutlet var btnMore: UIButton!
  @IBOutlet var btnMic: UIButton!
  @IBOutlet var btnSend: UIButton!
  @IBOutlet var inputRightConstraint: NSLayoutConstraint!
  @IBOutlet var inputHeightConstraint: NSLayoutConstraint!
  @IBOutlet var placeholder: UILabel!
  @IBOutlet var input: UITextView!
  @IBOutlet var messages: UIMessageList!
  @IBOutlet var spinner: UIActivityIndicatorView!
  @IBOutlet var inputContainerBottom: NSLayoutConstraint!
  @IBOutlet var privateChat: UILabel!
  
  var speechRecognizer = SpeechRecognizer()
  
  var replyingTo: Message? = nil
  
  
  override public func viewDidLoad() {
    super.viewDidLoad()
    let t = Theme.current
    let c = t.colors
    let f = t.fonts
    groupCount.textColor = c.caption.ui
    groupCount.superview?.subviews.first?.tintColor = c.caption.ui
    lblTitle.font = f.title2
    lblTitle.textColor = c.text.ui
    headerImage.tintColor = c.text.ui
    placeholder.font = f.body
    input.font = f.body
    btnSend.tintColor = c.primary.ui
    self.spinner = UIActivityIndicatorView.init(style: .large)
    self.view.addSubview(spinner)
    spinner.snp.makeConstraints { make in
      make.center.equalTo(view.snp.center)
    }
    speechRecognizer.objectWillChange
      .makeConnectable()
      .autoconnect()
      .sink { [weak self] _ in
        self?.updateSpeech()
      }.store(in: &bag)
    if let chat = chat {
      bind(chat: chat)
    } else if let user = user {
      bind(user: user)
    }
    NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
    NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
  }
  
  var original: CGFloat = 0
  @objc private func keyboardWillShow(notification: NSNotification){
    guard let keyboardFrame = notification.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
    if original == 0 {
      original = inputContainerBottom.constant
    }
    inputContainerBottom.constant = keyboardFrame.cgRectValue.size.height - self.view.safeBottomInset + 8.0
    let duration = (notification.userInfo![UIResponder.keyboardAnimationDurationUserInfoKey] as? Double) ?? 0.25
    UIView.animate(withDuration: duration) {
      self.view.layoutIfNeeded()
    }
  }
  
  @objc private func keyboardWillHide(notification: NSNotification){
    guard let keyboardFrame = notification.userInfo![UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue else { return }
    inputContainerBottom.constant = original
    let duration = (notification.userInfo![UIResponder.keyboardAnimationDurationUserInfoKey] as? Double) ?? 0.25
    UIView.animate(withDuration: duration) {
      self.view.layoutIfNeeded()
    }
  }
  
  var initialInputHeight: CGFloat = 0.0
  override public func viewDidAppear(_ animated: Bool) {
    self.initialInputHeight = inputHeightConstraint.constant
    chat?.markRead()
    Chat.current = chat?.id
  }
  
  public override func viewWillDisappear(_ animated: Bool) {
    if Chat.current == chat?.id {
      Chat.current = nil
    }
  }
  
  func updateSpeech() {
    if !speechRecognizer.transcript.isEmpty {
      input.text = (input.text ?? "") + speechRecognizer.transcript
      speechRecognizer.transcript = ""
    }
  }
  
  deinit {
    bag.forEach {$0.cancel()}
    bag.removeAll()
  }
  
  func bind(user: User) {
    lblTitle.text = user.displayNameFb
    groupCount.superview?.removeFromSuperview()
    if let img = user.avatar {
      headerImage.sd_setImage(with: img.url)
      headerImage.isHidden = false
      groupPlaceholder.isHidden = true
    } else {
      headerImage.image = AssetImage("user-fill")
      headerImage.isHidden = false
      groupPlaceholder.isHidden = true
    }
    self.spinner.isHidden = false
    self.input.isEditable = false
    self.messages.view.isHidden = true
  }
  
  func notFound() {
    self.spinner.isHidden = true
    let label = UILabel(frame: .zero)
    self.view.addSubview(label)
    label.snp.makeConstraints { make in
      make.center.equalTo(self.messages.view.snp.center)
    }
    label.text = "Chat not found"
  }
  
  func bind(chat: Chat) {
//    self.messages.view.isHidden = false
    self.spinner.isHidden = true
    lblTitle.text = chat.displayName
    if chat.isDM {
      groupCount.superview?.removeFromSuperview()
    } else {
      if let g = groupCount.superview, g.superview == nil {
        (lblTitle.superview as? UIStackView)?.addArrangedSubview(g)
      }
      groupCount.text = String(chat.activeMembers.count)
    }
    if let img = chat.displayImage {
      headerImage.sd_setImage(with: img.url)
      headerImage.isHidden = false
      groupPlaceholder.isHidden = true
    } else if chat.isDM {
      headerImage.image = AssetImage("user-fill")
      headerImage.isHidden = false
      groupPlaceholder.isHidden = true
    } else  {
      headerImage.isHidden = true
      groupPlaceholder.isHidden = false
    }
    if chat._private && !chat.isMember {
      if privateChat == nil {
        privateChat = UILabel()
        view.addSubview(privateChat)
        privateChat.numberOfLines = 0
        privateChat.snp.makeConstraints { make in
          make.horizontalEdges.equalToSuperview().inset(54)
          make.centerY.equalToSuperview()
        }
      }
      privateChat.isHidden = false
      privateChat.text = "This is a private chat. Gain membership in order to view messages."
      self.input.isEditable = false
    } else {
      privateChat?.isHidden = true
      self.input.isEditable = true
    }
  }
  
  @IBAction func mic() {
    if speechRecognizer.transcribing {
      input.text += speechRecognizer.transcript
    }
    speechRecognizer.toggle()
    btnMic.setImage(UIImage(systemName: speechRecognizer.transcribing ? "mic.slash.fill" : "mic.fill"), for: .normal)
  }
  
  var checkSend = true
  
  func checkMembership() -> Bool {
    if chat?.isMember != true {
      let alert = UIAlertController(title: "Membership Required", message: "To send messages to this chat, you have to join it. Would you like to?", preferredStyle: .alert)
      alert.addAction(UIAlertAction(title: "Maybe Later", style: .cancel))
      alert.addAction(UIAlertAction(title: "Join", style: .default, handler: { _ in
        self.chat?.join()
        self.view.makeToast("Chat joined")
        if self.checkSend {
          self.send()
        } else {
          self.tapMedia()
        }
      }))
      self.present(alert, animated: true)
      return false
    }
    return true
  }
  
  @IBAction func send() {
    checkSend = true
    if !checkMembership() {
      return
    }
    if let text = input.text, !text.isEmpty {
      chat?.send(text, inReplyTo: replyingTo)
      input.text = ""
      replyingTo = nil
      onEmptyInput()
      inputHeightConstraint.constant = initialInputHeight
      placeholder.isHidden = false
    }
  }
  
  var video = false
  @IBAction func camera(video: Bool = false) {
    self.video = video
    let imagePicker = UIImagePickerController()
    imagePicker.allowsEditing = false
    imagePicker.sourceType = .camera
    imagePicker.mediaTypes = video ? [UTType.movie.identifier] : [UTType.image.identifier]
    imagePicker.delegate = self
    self.present(imagePicker, animated: true)
  }
  
  @IBAction func library(video: Bool = false) {
    self.video = video
    var config = PHPickerConfiguration(photoLibrary: .shared())
    config.filter = video ? .videos : .images
    config.preferredAssetRepresentationMode = .current
    let picker = PHPickerViewController(configuration: config)
    picker.delegate = self
    self.present(picker, animated: true)
  }
  
  @IBAction func contact() {
    let picker = CNContactPickerViewController()
    picker.delegate = self
    self.present(picker, animated: true)
  }
  
  public func contactPicker(_ picker: CNContactPickerViewController, didSelect contact: CNContact) {
    chat?.send(contact: contact, inReplyTo: replyingTo)
    replyingTo = nil
    self.dismiss(animated: true)
  }
  
  public func contactPickerDidCancel(_ picker: CNContactPickerViewController) {
    self.dismiss(animated: true)
  }
  
  @IBAction func document(_ audio: Bool) {
    let picker = UIDocumentPickerViewController(
      forOpeningContentTypes: audio ? [.audio] : [.fileURL], asCopy: true)
    picker.allowsMultipleSelection = false
    picker.delegate = self
    self.present(picker, animated: true)
  }
  
  public func documentPicker(
    _ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]
  ) {
    print("Selected files", urls)
    if let fileURL = urls.first {
      do {
        let tmp = try copyFileToTemp(url: fileURL)
        publish {
          self.chat?.send(file: File(url: tmp), type: .file, inReplyTo: self.replyingTo)
          self.replyingTo = nil
        }
      } catch let err {
        print("err failed to copy doc", err)
      }
    } else {
      print("No files picked")
    }
    print("")
  }
  
  @IBAction func giphy() {
    let picker = GiphyViewController()
    picker.delegate = self
    picker.mediaTypeConfig = [.gifs]
    self.present(picker, animated: true)
  }
  
  @objc public func didSelectMedia(giphyViewController: GiphyViewController, media: GPHMedia) {
    if let gifURL = media.url(rendition: .fixedWidth, fileType: .gif),
       let url = URL(string: gifURL) {
      chat?.send(attachment: .init(id: UUID().uuidString, type: .case(.image), url: url.absoluteString), inReplyTo: replyingTo)
      replyingTo = nil
    }
    self.dismiss(animated: true)
  }
  
  @objc public func didDismiss(controller: GiphyViewController?) {
    self.dismiss(animated: true)
  }
  
  @IBAction func location() {
    self.chat?.sendLocation(inReplyTo:replyingTo)
    replyingTo = nil
  }
  
  func onEmptyInput() {
    inputRightConstraint.constant = 16.0
    btnSend.isHidden = true
  }
  
  func emojiKeyboard() {
    let keyboardSettings = KeyboardSettings(bottomType: .categories)
    keyboardSettings.needToShowDeleteButton = false
    keyboardSettings.needToShowAbcButton = false
    let emojiView = EmojiView(keyboardSettings: keyboardSettings)
    emojiView.translatesAutoresizingMaskIntoConstraints = false
    emojiView.delegate = self
    input.inputView = emojiView
    input.becomeFirstResponder()
  }
  
  public func emojiViewDidSelectEmoji(_ emoji: String, emojiView: EmojiView) {
    messageForAction?.react(emoji)
    input.resignFirstResponder()
    messageForAction = nil
  }
  
  public func emojiViewDidPressDismissKeyboardButton(_ emojiView: EmojiView) {
    input.resignFirstResponder()
    messageForAction = nil
  }
  
  @IBAction func back() {
    self.navigationController?.popViewController(animated: true)
    chat?.markRead()
  }
  
  @IBAction func more() {
    if let chat = chat {
      if chat.isDM == true, let user = chat.friend {
        self.performSegue(withIdentifier: "user", sender: user)
      } else {
        self.performSegue(withIdentifier: "group", sender: chat)
      }
    }
  }
  
  var messageForAction: Message? = nil
  override public func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "messages" {
      messages = segue.destination as? UIMessageList
      messages.chat = chat
      if chat == nil {
        messages.view.isHidden = true
      }
      messages.onLongPress = { [weak self] message in
        self?.messageForAction = message
        self?.performSegue(withIdentifier: "message-action", sender: message)
      }
      messages.onPressUser = {[weak self] user in
        self?.performSegue(withIdentifier: "user", sender: user)
      }
      if chat?._private == true && chat?.isMember == false {
        messages.view.isHidden = true
      }
    } else if segue.identifier == "group" {
      let group = segue.destination as? UIGroupDrawer
      group?.chat = sender as? Chat
      group?.room = self
    } else if segue.identifier == "user" {
      let user = segue.destination as? UIProfile
      user?.user = sender as? User
    } else if segue.identifier == "media" {
      (segue.destination as? UIPickAttachment)?.p = self
    } else if segue.identifier == "message-action" {
      let ma = segue.destination as? UIMessageActions
      ma?.room = self
    } else if segue.identifier == "edit" {
      let d = segue.destination as? UICreateChat
      d?.chat = chat
    } else if segue.identifier == "invite" {
      let d = segue.destination as? UIInviteUsers
      d?.chat = chat
    }
  }
  
  @IBAction func tapMedia() {
    checkSend = false
    if !checkMembership() {
      return
    }
    self.performSegue(withIdentifier: "media", sender: nil)
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
      send()
      return false
    }
    return true
  }
  
  public func textViewDidChange(_ textView: UITextView) {
    let text = textView.text ?? ""
    let oldHeight = textView.frame.height
    let maxHeight: CGFloat = 100.0
    let newHeight = ceil(min(textView.sizeThatFits(CGSize(width: textView.frame.width, height: CGFloat.greatestFiniteMagnitude)).height, maxHeight))
    var didChange = false
    if newHeight != oldHeight {
      inputHeightConstraint.constant = newHeight
      didChange = true
    }
    placeholder.isHidden = !text.isEmpty
    if !text.isEmpty && inputRightConstraint.constant == 16.0 {
      didChange = true
      inputRightConstraint.constant = 68.0
      btnSend.isHidden = false
    } else if text.isEmpty && inputRightConstraint.constant == 68.0 {
      onEmptyInput()
      didChange = true
    }
    if didChange {
      input.setNeedsLayout()
      input.layoutIfNeeded()
    }
  }
  
  func onVideo(_ url: URL) {
    print("On Video", url.absoluteString)
    chat?.send(
      file: File(url: url),
      type: .video,
      inReplyTo: replyingTo)
    replyingTo = nil
  }
  
  func onImage(_ url: URL) {
    print("on Image \(url)")
    chat?.send(
      file: File(url: url),
      type: .image,
      inReplyTo: replyingTo)
    replyingTo = nil
  }
  
  public func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
    self.dismiss(animated: true)
    let identifier = [ UTType.mpeg4Movie, UTType.quickTimeMovie, UTType.mpeg, UTType.avi, UTType.movie, UTType.video]
    print("picker did finsih picking", results)
    if let result = results.first
    {
      if self.video, let match = identifier.first(where: {
        result.itemProvider.hasItemConformingToTypeIdentifier($0.identifier)
      }) {
        let progress = result.itemProvider.loadFileRepresentation(forTypeIdentifier: match.identifier) {
          url, err in
          if let err = err {
            print("Error Loading File", err)
          } else if let url = url {
            do {
              let tmp = try tmpFile(ext: match.preferredFilenameExtension)
              print("Copy from url", url.absoluteString, "to", tmp.absoluteString)
              try FileManager.default.copyItem(
                at: url, to: tmp)
              DispatchQueue.main.async {
                self.onVideo(tmp)
              }
            } catch let err {
              print("Failed to copy file", err)
            }
          }
        }
        print("Getting file for ", match)
      } else {
        result.file { tmp in
          DispatchQueue.main.async {
            self.onImage(tmp)
          }
        }
      }
    } else {
      print("No picker results")
    }
  }
  
  static func instance() -> UIChatRoom {
    return UIStoryboard(name: "InAppChat", bundle: assets).instantiateViewController(withIdentifier: "chat") as! UIChatRoom
  }
}

extension UIImage {
  func png(isOpaque: Bool = true) -> Data? { flattened(isOpaque: isOpaque)?.pngData() }
  func flattened(isOpaque: Bool = true) -> UIImage? {
    if imageOrientation == .up { return self }
    UIGraphicsBeginImageContextWithOptions(size, isOpaque, scale)
    defer { UIGraphicsEndImageContext() }
    draw(in: CGRect(origin: .zero, size: size))
    return UIGraphicsGetImageFromCurrentImageContext()
  }
}

public struct ChatRoom: View {

  enum Media {
    case pickPhoto
    case pickVideo
    case recordPhoto
    case recordVideo
    case gif
    case file
    case contact
  }

  @Environment(\.iacTheme) var theme

  @FocusState var textFocus
  @Environment(\.geometry) var geometry
  @EnvironmentObject var navigator: Navigator

  @State var menu: Bool = false
  @State var media: Bool = false
  @State var messageForAction: Message? = nil
  @State var messageForEmojiKeyboard: Message? = nil
  @State var selectMedia: Media? = nil

  @ObservedObject var chat: Chat
  let message: Message?
  public init(chat: Chat, message: Message?) {
    self._chat = ObservedObject(initialValue: chat)
    self.message = message
  }

  var messageAction: some View {
    ActionSheet {
      VStack {
        EmojiBar(
          currentEmoji: messageForAction?.currentReaction,
          onEmoji: {
            messageForAction?.react($0)
            messageForAction = nil
          }
        ) {
          messageForEmojiKeyboard = messageForAction
          messageForAction = nil
        }
      }.padding(.horizontal, 16.0)
        .padding(.top, 12.0)
      ActionItem(image: AssetImage("chat-dots").image, text: "Reply in chat") {
        navigator.navigate(messageForAction!.path)
        messageForAction = nil
      }
      ActionItem(
        image: AssetImage("star").image,
        text: messageForAction?.favorite == true ? "Remove from favorites" : "Save to favorites"
      ) {
        messageForAction?.toggleFavorite()
        messageForAction = nil
      }
      if let text = messageForAction?.text, !text.isEmpty {
        ActionItem(
          image: AssetImage("copy").image,
          text: "Copy"
        ) {
          UIPasteboard.general.string = text
          messageForAction = nil
        }
      }
    }.background(BackgroundClearView())
  }

  func selectMedia(_ media: Media) {
    self.media = false
    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
      self.selectMedia = media
    }
  }

  var attachmentActions: some View {
    ActionSheet {
      ActionItem(image: AssetImage("image-square").image, text: "Upload Photo", divider: false) {
        self.selectMedia(.pickPhoto)
      }
      ActionItem(image: AssetImage("camera").image, text: "Take Photo", divider: true) {
        self.selectMedia(.recordPhoto)
      }
      ActionItem(image: AssetImage("file-video").image, text: "Upload Video", divider: false) {
        self.selectMedia(.pickVideo)
      }
      ActionItem(image: AssetImage("video-camera").image, text: "Video Camera", divider: true) {
        self.selectMedia(.recordVideo)
      }
      ActionItem(image: AssetImage("gif").image, text: "Send a GIF", divider: true) {
        self.selectMedia(.gif)
      }
      ActionItem(image: AssetImage("map-pin").image, text: "Send Location", divider: true) {
        media = false
        self.chat.sendLocation(inReplyTo: message)
      }
      ActionItem(image: AssetImage("address-book").image, text: "Share Contact", divider: true) {
        media = false
        self.selectMedia(.contact)
      }
    }.background(BackgroundClearView())
  }

  var currentPicker: AnyView? {
    if let media = selectMedia {
      switch media {
      case .recordPhoto, .recordVideo:
        let video = selectMedia == .recordVideo
        return AnyView(
          CameraPicker(video: video) {
            if video {
              self.onVideo($0)
            } else {
              self.onImage($0)
            }
          })
      case .pickVideo, .pickPhoto:
        let video = selectMedia == .pickVideo
        return AnyView(
          PhotoPicker(video: video, onProgress: { $0.resume() }) {
            if video {
              self.onVideo($0)
            } else {
              self.onImage($0)
            }
          })
      case .contact:
        return AnyView(
          ContactPicker {
            chat.send(contact: $0, inReplyTo: message)
          })
      case .file:
        return AnyView(
          DocumentPicker {
            chat.send(file: File(url: $0), type: .file, inReplyTo: message)
          }
        )
      case .gif:
        return AnyView(
          GiphyPicker {
            chat.send(attachment: .init(id: UUID().uuidString, type: .case(.image), url: $0.absoluteString), inReplyTo: message)
          }
        )
      }
    } else {
      return nil
    }
  }

  var pickers: some View {
    ZStack {
      currentPicker
    }
    .background(BackgroundClearView())
    .cornerRadius(12.0)
  }

  public var body: some View {
    ZStack {
      MessageList(chat: chat, onLongPress: { messageForAction = $0 })
      Header(
        title: "",
        onBack: {
          navigator.goBack()
          chat.markRead()
        },
        onMenu: chat.isGroup
          ? {
            menu = true
          } : nil
      ) {
        HStack {
          Avatar(url: chat.image, size: 35, group: chat.isGroup)
          VStack(alignment: .leading, spacing: 0) {
            Text(chat.displayName.maxLength(15))
              .lineLimit(1)
              .font(theme.fonts.title2.font)
              .foregroundColor(theme.colors.text)
              .frame(maxWidth: geometry.width - 140.0)
            if chat.isGroup {
              GroupCount(count: chat.activeMembers.count)
            }
          }
        }.fixedSize()
      }.position(x: geometry.width / 2.0, y: (geometry.insets.top + Header<Image>.height) / 2.0)
      MessageInput(chat: chat, replyingTo: message, onMedia: { media = true })
        .position(x: geometry.width / 2.0, y: geometry.height - geometry.insets.bottom - 31.0)
      HappyPanel(isOpen: $messageForEmojiKeyboard.mappedToBool()) {
        messageForEmojiKeyboard?.react($0)
        messageForEmojiKeyboard = nil
        messageForAction = nil
      }
    }
    .sheet(isPresented: $media) {
      attachmentActions.background(TransparentBackground())
    }.sheet(isPresented: $messageForAction.mappedToBool()) {
      messageAction.background(TransparentBackground())
    }
    .sheet(isPresented: $selectMedia.mappedToBool()) {
      pickers.background(TransparentBackground())
    }.sheet(isPresented: $menu) {
      if chat.isGroup {
        GroupDrawer(chat).background(TransparentBackground())
      }
    }.onAppear {
      chat.markRead()
    }
  }
  

  func onVideo(_ url: URL) {
    print("On Video", url.absoluteString)
    chat.send(
      file: File(url: url),
      type: .video,
      inReplyTo: self.message)
  }

  func onImage(_ url: URL) {
    chat.send(
      file: File(url: url),
      type: .image,
      inReplyTo: message)
  }
}


struct TransparentBackground: UIViewRepresentable {
  @MainActor
  private static var backgroundColor: UIColor?
  
  func makeUIView(context: Context) -> UIView {
    let view = UIView()
    Task {
      Self.backgroundColor = view.superview?.superview?.backgroundColor
      view.superview?.superview?.backgroundColor = .clear
    }
    return view
  }
  
  static func dismantleUIView(_ uiView: UIView, coordinator: ()) {
    uiView.superview?.superview?.backgroundColor = Self.backgroundColor
  }
  
  func updateUIView(_ uiView: UIView, context: Context) {}
}

extension String {
  func maxLength(_ l: Int) -> String {
    if self.count > l {
      return self[startIndex..<self.index(startIndex, offsetBy: l)] + "..."
    } else {
      return self
    }
  }
}

public class UIPickAttachment: UIViewController {
  
  var _p: UIChatRoom!
  
  var p: UIChatRoom! {
    get {
      _p.dismiss(animated: true)
      return _p
    }
    set {
      _p = newValue
    }
  }
  
  @IBAction func pickPhoto() {
    p.library()
  }
  
  @IBAction func takePhoto() {
    p.camera()
  }
  
  @IBAction func pickVideo() {
    p.library(video: true)
  }
  
  @IBAction func takeVideo() {
    p.camera(video: true)
  }
  
  @IBAction func gif() {
    p.giphy()
  }
  
  @IBAction func location() {
    p.location()
  }
  
  @IBAction func contact() {
    p.contact()
  }
  
  @IBAction func onTapBG() {
    self.dismiss(animated: true)
  }
}
