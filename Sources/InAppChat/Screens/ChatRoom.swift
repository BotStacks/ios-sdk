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

public class UIChatRoom: UIViewController {
  
  var chat: Chat! {
    didSet {
      
    }
  }
  
  @IBOutlet var groupCount: UILabel!
  @IBOutlet var lblTitle: UILabel!
  @IBOutlet var btnBack: UIButton!
  @IBOutlet var headerImage: SDAnimatedImageView!
  @IBOutlet var btnMore: UIButton!
  @IBOutlet var btnMic: UIButton!
  @IBOutlet var btnSend: UIButton!
  @IBOutlet var inputRightConstraint: NSLayoutConstraint!
  @IBOutlet var inputHeightConstraint: NSLayoutConstraint!
  
  @IBOutlet var input: UITextView!
  
  
  
  
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
