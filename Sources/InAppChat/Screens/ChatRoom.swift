//
//  ChatRoom.swift
//  InAppChat
//
//  Created by Zaid Daghestani on 2/2/23.
//

import Foundation
import SwiftUI
import UIKit

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

  @ObservedObject var thread: Thread
  let message: Message?
  public init(thread: Thread, message: Message?) {
    self._thread = ObservedObject(initialValue: thread)
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
      ActionItem(image: AssetImage("chat-dots"), text: "Reply in Thread") {
        navigator.navigate("/message/\(messageForAction!.id)")
        messageForAction = nil
      }
      ActionItem(
        image: AssetImage("star"),
        text: messageForAction?.favorite == true ? "Remove from favorites" : "Save to favorites"
      ) {
        messageForAction?.toggleFavorite()
        messageForAction = nil
      }
      if let text = messageForAction?.text, !text.isEmpty {
        ActionItem(
          image: AssetImage("copy"),
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
      ActionItem(image: AssetImage("image-square"), text: "Upload Photo", divider: false) {
        self.selectMedia(.pickPhoto)
      }
      ActionItem(image: AssetImage("camera"), text: "Take Photo", divider: true) {
        self.selectMedia(.recordPhoto)
      }
      ActionItem(image: AssetImage("file-video"), text: "Upload Video", divider: false) {
        self.selectMedia(.pickVideo)
      }
      ActionItem(image: AssetImage("video-camera"), text: "Video Camera", divider: true) {
        self.selectMedia(.recordVideo)
      }
      ActionItem(image: AssetImage("gif"), text: "Send a GIF", divider: true) {
        self.selectMedia(.gif)
      }
      ActionItem(image: AssetImage("map-pin"), text: "Send Location", divider: true) {
        media = false
        self.thread.sendLocation(inReplyTo: message)
      }
      ActionItem(image: AssetImage("address-book"), text: "Share Contact", divider: true) {
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
            thread.send(contact: $0, inReplyTo: message)
          })
      case .file:
        return AnyView(
          DocumentPicker {
            thread.send(file: $0, inReplyTo: message)
          }
        )
      case .gif:
        return AnyView(EmptyView())
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
      MessageList(thread: thread, onLongPress: { messageForAction = $0 })
      Header(
        title: "",
        onMenu: thread.group != nil
          ? {
            menu = true
          } : nil
      ) {
        HStack {
          Avatar(url: thread.image, size: 35, group: thread.group != nil)
          VStack(alignment: .leading, spacing: 0) {
            Text(thread.name)
              .lineLimit(1)
              .font(theme.fonts.title2)
              .foregroundColor(theme.colors.text)
            if let group = thread.group {
              GroupCount(count: group.participants.count)
            }
          }
        }.fixedSize()
      }.position(x: geometry.width / 2.0, y: (geometry.insets.top + Header<Image>.height) / 2.0)
      MessageInput(thread: thread, replyingTo: message, onMedia: { media = true })
        .position(x: geometry.width / 2.0, y: geometry.height - geometry.insets.bottom - 31.0)
      HappyPanel(isOpen: $messageForEmojiKeyboard.mappedToBool()) {
        messageForEmojiKeyboard?.react($0)
        messageForEmojiKeyboard = nil
        messageForAction = nil
      }
    }
    .sheet(isPresented: $media) {
      attachmentActions
    }.sheet(isPresented: $messageForAction.mappedToBool()) {
      messageAction
    }
    .sheet(isPresented: $selectMedia.mappedToBool()) {
      pickers
    }.sheet(isPresented: $menu) {
      if let group = thread.group {
        GroupDrawer(group)
      }
    }
  }

  func onVideo(_ url: URL) {
    print("On Video", url.absoluteString)
    thread.send(
      attachment: .init(url: url.absoluteString, kind: .video, type: nil),
      inReplyTo: self.message)
  }

  func onImage(_ url: URL) {
    thread.send(
      attachment: .init(url: url.absoluteString, kind: .image, type: nil),
      inReplyTo: message)
  }
}
