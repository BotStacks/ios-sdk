//
//  Attachment+Fakes.swift
//  InAppChat
//
//  Created by Zaid Daghestani on 1/31/23.
//

import Foundation

let attachmentKinds: [Message.Attachment.Kind] = [.audio, .image, .file, .video]

extension Message.Attachment {
  static func gen(kind: Message.Attachment.Kind? = nil) -> Message.Attachment {
    let _kind = kind ?? attachmentKinds.randomElement()!
    var url: String!
    switch _kind {
    case .video:
      url = "https://download.samplelib.com/mp4/sample-5s.mp4"
      break
    case .audio:
      url =
        "https://file-examples.com/storage/fe0358100863d05afed02d2/2017/11/file_example_MP3_5MG.mp3"
      break
    case .image, .file:
      url = randomImage()
      break
    }
    return .init(url: url, kind: _kind)
  }
}
