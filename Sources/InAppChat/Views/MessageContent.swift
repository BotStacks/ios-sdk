//
//  MessageContent.swift
//  InAppChat
//
//  Created by Zaid Daghestani on 2/1/23.
//

import Foundation
import SwiftUI
import AVKit

public struct MessageContent: View {

  @Environment(\.iacTheme) var theme
  let message: Message
  
  func text(_ text: String) -> some View {
    Text(.init(text))
      .font(theme.fonts.body)
      .foregroundColor(
        message.user.isCurrent  ? theme.colors.senderText : theme.colors.text
      )
      .padding(theme.bubblePadding)
      .tint(theme.colors.primary)
  }

  public var body: some View {
    VStack {
      var markdown: String? = nil
      if let attachments = message.attachments {
        HStack {
          ForEach(attachments, id: \.id) { attachment in
            if attachment.type == .image {
              GifImageView(url: attachment.url)
                .aspectRatio(contentMode: .fill)
                .scaledToFill()
                .size(self.theme.imagePreviewSize)
            } else if attachment.type == .video {
              AZVideoPlayer(player: AVPlayer(url: try! attachment.url.asURL()))
                .size(self.theme.videoPreviewSize)
            } else if attachment.type == .audio {
              AudioView(attachment.url)
            } else if attachment.type == .file {
              AssetImage("file-arrow-down-fill")
                .resizable()
                .foregroundColor(
                  message.user.isCurrent ? theme.colors.senderText : theme.colors.text
                )
                .size(64.0)
            } else if attachment.type == .location, let md = attachment.loc?.markdownLink {
              text(md)
            } else if attachment.type == .contact, let md = attachment.contact?.markdown {
              text(md)
            }
          }
        }
      }
      let md = message.markdownText
      if !md.isEmpty {
        text(md)
      }
    }
    .background(message.user.isCurrent ? theme.colors.senderBubble : theme.colors.bubble)
    .cornerRadius(theme.bubbleRadius)
  }

}
