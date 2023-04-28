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

  public var body: some View {
    VStack {
      if let attachment = message.attachments.first {
        if attachment.kind == .image {
          GifImageView(url: attachment.url)
            .aspectRatio(contentMode: .fill)
            .scaledToFill()
            .size(self.theme.imagePreviewSize)
        } else if attachment.kind == .video {
          AZVideoPlayer(player: AVPlayer(url: try! attachment.url.asURL()))
            .size(self.theme.videoPreviewSize)
        } else if attachment.kind == .audio {
          AudioView(attachment.url)
        } else if attachment.kind == .file {
          AssetImage("file-arrow-down-fill")
            .resizable()
            .foregroundColor(
              message.user.isCurrent ? theme.colors.senderText : theme.colors.text
            )
            .size(64.0)
        }
      } else {
        let text =
          message.location?.markdownLink ?? message.contact?.markdown ?? message.markdownText
        Text(.init(text))
          .font(theme.fonts.body)
          .foregroundColor(
            message.user.isCurrent  ? theme.colors.senderText : theme.colors.text
          )
          .padding(theme.bubblePadding)
          .tint(theme.colors.primary)
      }
    }
    .background(message.user.isCurrent ? theme.colors.senderBubble : theme.colors.bubble)
    .cornerRadius(theme.bubbleRadius)
  }

}
