import SwiftDate
import SnapKit
import SwiftUI
import UIKit
import SDWebImage
import AVKit
import Combine

public class UIVideo: UIView {
  
  var url: String? {
    didSet {
      update()
    }
  }
  
  func update() {
    self.subviews.forEach { $0.removeFromSuperview() }
    if let url = url?.url {
      let player = AVPlayer(url: url)
      player.isMuted = true
      let video = AVPlayerViewController()
      video.player = player
      video.view.frame = bounds
      video.showsPlaybackControls = true
      addSubview(video.view)
      player.play()
      NotificationCenter.default.addObserver(forName: .AVPlayerItemDidPlayToEndTime, object: player.currentItem, queue: .main) { _ in
        player.seek(to: CMTime.zero)
        player.play()
      }
    } else {
      self.subviews.forEach { $0.removeFromSuperview() }
    }
  }
}

public class UIMessageRow: UITableViewCell {
  
  var onTapReplies: ((Message) -> Void)!
  var onPressUser: ((User) -> Void)!
  
  static func identifier(for message: Message) -> String {
    if let at = message.attachments?.first {
      if at.type == .image || at.type == .file {
        return "image"
      } else if at.type == .video || at.type == .audio {
        return "video"
      }
    }
    return "markdown"
  }
  
  @IBOutlet var avatar: SDAnimatedImageView!
  @IBOutlet var icon: UIImageView!
  @IBOutlet var username: UILabel!
  @IBOutlet var timestamp: UILabel!
  @IBOutlet var content: UIView!
  @IBOutlet var markdown: UILabel?
  @IBOutlet var img: SDAnimatedImageView?
  @IBOutlet var video: UIVideo?
  @IBOutlet var favorite: UIImageView!
  @IBOutlet var avatarLeft: NSLayoutConstraint!
  
  var sub: AnyCancellable? = nil
  
  var message: Message! {
    didSet {
      bindUI()
      sub?.cancel()
      sub = message.objectWillChange.makeConnectable()
        .autoconnect()
        .sink { [weak self] _ in
          DispatchQueue.main.async {
            self?.bindUI()
          }
        }
    }
  }
  
  func apply(size: CGSize, to constraints: [NSLayoutConstraint]) {
    constraints.forEach { it in
      if it.firstAttribute == .width {
        it.constant = size.width
      } else if it.firstAttribute == .height {
        it.constant = size.height
      }
    }
  }
  
  public override func awakeFromNib() {
    let t = Theme.current
    let f = t.fonts
    let c = t.colors
    avatar.superview?.backgroundColor = c.softBackground.ui
    icon.tintColor = c.text.ui
    username.textColor = c.username.ui
    username.font = f.username
    timestamp.textColor = c.timestamp.ui
    timestamp.font = f.timestamp
    content.backgroundColor = c.bubble.ui
    favorite.tintColor = c.primary.ui
    markdown?.font = Theme.current.fonts.body
    if let img = img {
      apply(size: t.imagePreviewSize, to: img.constraints)
    }
    if let video = video {
      apply(size: t.videoPreviewSize, to: video.constraints)
    }
    self.setNeedsLayout()
  }
  
  func bindUI() {
    let m = message!
    if let img = m.user.avatar {
      avatar.sd_setImage(with: img.url)
      avatar.isHidden = false
      icon.isHidden = true
    } else {
      icon.isHidden = false
      avatar.isHidden = true
    }
    username.text = m.user.displayNameFb
    timestamp.text = m.createdAt.toString(.time(.short))
    if message.favorite {
      avatarLeft.constant = 24.0
    } else {
      avatarLeft.constant = 0.0
    }
    var md = message.markdownText
    if let at = m.attachments?.first {
      switch at.type {
      case .image:
        fallthrough
      case .file:
        if at.type == .file {
          img?.image = AssetImage("file-arrow-down-fill")
        } else {
          img?.sd_setImage(with: at.url.url)
        }
        break
      case .audio:
        fallthrough
      case .video:
        video?.url = at.url
        break
      case .location:
        md = at.loc?.markdownLink ?? ""
        break
      case .vcard:
        md = at.contact?.markdown ?? ""
        break
      default:
        break
      }
    }
    markdown?.attributedText = md.isEmpty ? .init(string: "") :  .init((try? AttributedString(markdown: md)) ?? AttributedString(""))
    if message.sending {
      if spinner == nil {
        let spinner = UIActivityIndicatorView.init(style: .large)
        spinner.color = c().primary.ui
        spinner.hidesWhenStopped = true
        self.spinner = spinner
        content.superview?.addSubview(spinner)
        spinner.snp.makeConstraints { make in
          make.centerY.equalTo(content.snp.centerY)
          make.left.equalTo(content.snp.right).offset(12.0)
        }
      }
      spinner?.isHidden = false
      spinner?.startAnimating()
    } else {
      spinner?.stopAnimating()
      spinner?.isHidden = true
    }
    flip()
    content.backgroundColor = message.user.isCurrent ? c().senderBubble.ui : c().bubble.ui
    markdown?.textColor = message.user.isCurrent ? c().senderText.ui : c().bubbleText.ui
    self.setNeedsLayout()
    self.layoutIfNeeded()
  }
  
  func flip() {
    let t  = CGAffineTransformMakeScale(message.user.isCurrent ? -1 : 1, 1)
    contentView.layer.setAffineTransform(t)
    content.layer.setAffineTransform(t)
    username.layer.setAffineTransform(t)
    timestamp.layer.setAffineTransform(t)
    avatar.layer.setAffineTransform(t)
  }
  
  var spinner: UIActivityIndicatorView?
  
  @IBAction func tapReplies() {
    onTapReplies(message)
  }
  
  @IBAction func tapUser() {
    onPressUser(message.user)
  }
}

public class UIReactionsView: UITableViewCell {
  
  @IBOutlet var content: UIStackView!
  
  var message: Message! {
    didSet {
      render()
    }
  }
  
  func render() {
    contentView.layer.setAffineTransform(.init(scaleX: message.user.isCurrent ? -1 : 1, y: 1))
    if let reactions = message.reactions {
      for (i, r) in reactions.enumerated() {
        let old = i < content.subviews.count
        let pill = old ? content.subviews[i] as! UIReactionPill : UIReactionPill(frame: .zero)
        pill.set(message: message, reaction: r.reaction, count: r.uids.count, isCurrent: r.reaction == message.currentReaction)
        if !old {
          content.addArrangedSubview(pill)
        }
      }
      if reactions.count < content.subviews.count {
        for i in reactions.count..<content.subviews.count {
          content.subviews[i].isHidden = true
        }
      }
    } else {
      for subview in subviews {
        subview.isHidden = true
      }
    }
    self.setNeedsLayout()
    self.layoutIfNeeded()
  }
}

public class UIReactionPill: UIView {
  
  public override init(frame: CGRect) {
    super.init(frame: frame)
    build()
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
    build()
  }
  
  
  var label: UILabel!
  func build() {
    label = UILabel(frame: .zero)
    label.font = Theme.current.fonts.body
    label.textColor =  c().text.ui
    label.setContentHuggingPriority(.required, for: .horizontal)
    addSubview(label)
    label.snp.makeConstraints { make in
      make.horizontalEdges.equalToSuperview().inset(8.0)
      make.verticalEdges.equalToSuperview().inset(5.0)
    }
    backgroundColor = c().bubble.ui
    self.layer.borderColor = c().primary.cgColor
    self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(react)))
  }
  
  var reaction: String = "❤️"
  
  var message: Message!
  
  @objc func react() {
    message.react(reaction)
  }
  
  func set(message: Message, reaction: String, count: Int, isCurrent: Bool) {
    self.reaction = reaction
    self.message = message
    label.text = "\(reaction) \(count)"
    if isCurrent {
      self.layer.borderWidth = 2.0
    } else {
      self.layer.borderWidth = 0.0
    }
    backgroundColor = message.user.isCurrent ? c().senderBubble.ui : c().bubble.ui
    label.textColor = message.user.isCurrent ? c().senderText.ui : c().senderBubble.ui
    let t = CGAffineTransform(scaleX: message.user.isCurrent ? -1 : 1, y: 1)
    self.layer.setAffineTransform(t)
  }
  
  public override func layoutSubviews() {
    super.layoutSubviews()
    self.layer.cornerRadius = self.frame.size.height / 2.0
  }
  
  
  
}

public class UIRepliesCell: UITableViewCell {
  @IBOutlet var label: UILabel!
  
  var message: Message! {
    didSet {
      let t = CGAffineTransform(scaleX: message.user.isCurrent ? -1 : 1, y: 1)
      contentView.layer.setAffineTransform(t)
      label.layer.setAffineTransform(t)
      label.text = "\(message.replyCount) repl\(message.replyCount > 1 ? "ies" : "y")"
    }
  }
  
  override public func awakeFromNib() {
    label.font = Theme.current.fonts.body.bold
    label.textColor = c().primary.ui
  }
}

public struct MessageView: View {

  @Environment(\.iacTheme) var theme
  @ObservedObject var message: Message
  @ObservedObject var user: User
  
  init(message: Message) {
    self.message = message
    self.user = message.user
  }

  func topStack() -> some View {
    return HStack(alignment: .bottom, spacing: 8.0) {
      Text(message.user.username)
        .font(theme.fonts.username.font)
        .foregroundColor(theme.colors.username)
        .frame(maxWidth: 120.0)
        .truncationMode(.tail)
      Text(message.createdAt.toString(.time(.short)))
        .font(theme.fonts.timestamp.font)
        .foregroundColor(theme.colors.timestamp)
    }.fixedSize()
  }

  func content() -> some View {
    return VStack(
      alignment: message.user.isCurrent == true ? theme.senderAlign : theme.messageAlign,
      spacing: 4.0
    ) {
      topStack()
      MessageContent(message: message)
      reactions()
      replyCount()
    }
  }

  func reactions() -> some View {
    return message.reactions.map { reactions in
      return HStack(spacing: 8.0) {
        ForEach(reactions, id: \.reaction) { reaction in
          Button {
            message.react(reaction.reaction)
          } label: {
            Text("\(reaction.reaction) \(reaction.uids.count)")
              .font(theme.fonts.body.font)
              .foregroundColor(theme.colors.text)
              .padding(theme.bubblePadding)
              .background(theme.colors.bubble.new())
              .cornerRadius(36.0)
              .fixedSize()
              .overlay(
                RoundedRectangle(
                  cornerRadius: 36
                ).stroke(
                  message.currentReaction == reaction.reaction ? theme.colors.primary : Color.clear,
                  lineWidth: 2)
              )
          }
        }
      }
    }
  }

  func replyCount() -> some View {
    return message.replyCount > 0
      ? Text("\(message.replyCount) replies")
        .foregroundColor(self.theme.colors.primary)
        .padding(4.0)
        .font(theme.fonts.body.font.bold())
      : nil
  }

  func favorite() -> some View {
    ZStack {
      AssetImage("star-fill")
        .image
        .resizable()
        .size(20.0)
        .foregroundColor(theme.colors.primary)
    }.size(35.0)
  }

  public var body: some View {
    let align =
      message.user.isCurrent == true
      ? self.theme.senderAlign : self.theme.messageAlign
    if user.blocked {
      EmptyView()
    } else {
      VStack(alignment: align) {
        HStack(alignment: .top, spacing: 10.0) {
          let align = message.user.isCurrent == true ? theme.senderAlign : theme.messageAlign
          let avatar = NavLink(to: message.user.path) {
            Avatar(url: message.user.avatar)
          }
          if align == .trailing {
            Spacer()
            content()
            
            if theme.showAvatar {
              avatar
            }
            if message.favorite {
              favorite()
            }
            if message.status == .sending {
              Spinner()
                .size(20)
            }
          } else {
            if message.status == .sending {
              Spinner()
                .size(20)
            }
            if message.favorite {
              favorite()
            }
            if theme.showAvatar {
              avatar
            }
            content()
            Spacer()
          }
        }.padding(.vertical, 5.0)
          .padding(.horizontal, 10.0)
      }.onAppear {
        message.markRead()
      }
    }
  }

}
