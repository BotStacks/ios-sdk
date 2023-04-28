public extension MessageView {
   static var sample: MessageView {
    return MessageView(message: Message.sample)
  }

   static var sampleCurrent: MessageView {
    let message = Message.gen(user: User.sampleCurrent)
    return MessageView(message: message)
  }

   static var sampleImage: MessageView {
    return MessageView(message: Message.sampleImage)
  }

   static var sampleVideo: MessageView {
    return MessageView(
      message: Message.gen(attachments: [Message.Attachment(url: "https://download.samplelib.com/mp4/sample-5s.mp4", kind: .video)]))
  }

   static var sampleAudio: MessageView {
    return MessageView(
      message: Message.gen(attachments: [Message.Attachment(url: "https://file-examples.com/storage/fe0358100863d05afed02d2/2017/11/file_example_MP3_5MG.mp3", kind: .audio)]))
  }
  
  static var sampleMarkdown: MessageView {
    return MessageView(message: Message.gen(text: """
## Markdown

**This is bold text**

__This is bold text__

*This is italic text*

_This is italic text_

~~Strikethrough~~
links
-__[pica](https://nodeca.github.io/pica/demo/)__ - high quality and fast image
  resize in browser.
- __[babelfish](https://github.com/nodeca/babelfish/)__ - developer friendly
"""))
  }
  
  static var sampleMention: MessageView {
    return MessageView(message: Message.gen(text: "Hey @ripbullnetworks whats up"))
  }
  
  static var sampleLink: MessageView {
    return MessageView(message: Message.gen(text: "Hey @ripbullnetworks here's a phone https://media.giphy.com/media/BBCrN7G0zQqu2z8OhY/giphy.gif whats up"))
  }
  
  static var samplePhone: MessageView {
    return MessageView(message: Message.gen(text: "Hey @ripbullnetworks here's a phone +12131233214 whats up"))
  }

  static var sampleGif: MessageView {
    return MessageView(message: Message.sampleGif)
  }
}
