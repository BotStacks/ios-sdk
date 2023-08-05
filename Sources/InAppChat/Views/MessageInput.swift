//
//  MessageInput.swift
//  InAppChat
//
//  Created by Zaid Daghestani on 2/2/23.
//

import Foundation
import SwiftUI

struct FocusedMessageInputBinding: FocusedValueKey {
  typealias Value = Binding<Bool>
}

extension FocusedValues {
  var messageInputBinding: FocusedMessageInputBinding.Value? {
    get { self[FocusedMessageInputBinding.self] }
    set { self[FocusedMessageInputBinding.self] = newValue }
  }
}

public struct MessageInput: View {

  @Environment(\.iacTheme) var theme
  @FocusState var focus
  @State var text: String = ""
  @StateObject var speech = SpeechRecognizer()
  let replyingTo: Message?
  let onMedia: () -> Void

  @ObservedObject var chat: Chat

  init(chat: Chat, replyingTo: Message?, onMedia: @escaping () -> Void) {
    self._chat = ObservedObject(initialValue: chat)
    self.onMedia = onMedia
    self.replyingTo = replyingTo
  }

  public var body: some View {
    VStack {
      HStack(spacing: 5) {
        HStack(spacing: 0) {
          TextField("Send a chat...", text: $text)
            .background(.clear)
            .font(theme.fonts.body.font)
            .foregroundColor(theme.colors.text)
            .growX()
            .focused($focus)
          Button {
            onMedia()
          } label: {
            ZStack {
              AssetImage("paperclip-fill")
                .image
                .resizable()
                .size(20.0)
                .foregroundColor(theme.colors.caption)
            }.size(32)
          }
          if speech.enabled {
            Button {
              if speech.transcribing {
                text = text + speech.transcript
              }
              speech.toggle()
            } label: {
              ZStack {
                AssetImage(speech.transcribing ? "microphone-slash-fill" : "microphone-fill").image
                  .resizable()
                  .size(20.0)
                  .foregroundColor(
                    speech.transcribing ? theme.colors.destructive : theme.colors.caption)

              }.size(32)
            }
          }
        }
        .padding(.horizontal, 14)
        .height(44.0)
        .background(theme.colors.softBackground)
        .cornerRadius(22)
        Button {
          if !text.isEmpty {
            chat.send(text, inReplyTo: replyingTo)
            text = ""
          }
        } label: {
          ZStack {
            AssetImage("paper-plane-tilt-fill")
              .image
              .resizable()
              .size(20.0)
              .foregroundColor(theme.colors.primary)
          }.circle(44.0, theme.colors.softBackground)
        }
      }
    }
    .padding(.vertical, 9)
    .padding(.horizontal, 16)
    .background(.thinMaterial)
    .onTapGesture {
      self.focus = true
    }
  }
}
