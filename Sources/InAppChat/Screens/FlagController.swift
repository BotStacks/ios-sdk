//
//  FlagController.swift
//  InAppChat
//
//  Created by Zaid Daghestani on 8/24/23.
//

import Foundation
import UIKit


public class UIFlagController: UIViewController, UITextViewDelegate {
  
  @IBOutlet var reasonsStack: UIStackView!
  @IBOutlet var label: UILabel!
 
  var entityID: String {
    return user?.id ?? message?.id ?? chat?.id ?? ""
  }
  
  var reasons = [
    "Spam",
    "Nudity or sexual activity",
    "Hate speech or symbols",
    "False information",
    "Bullying or harassment",
    "Scam or fraud"
  ]
  
  var entity: String {
    return user != nil ? "User" : message != nil ? "Message" : "Chat"
  }
  var message: Message?
  var chat: Chat?
  var user: User?

  
  public override func viewDidLoad() {
    for (index, reason) in reasons.enumerated() {
      let view = UIView()
      reasonsStack.addArrangedSubview(view)
      view.snp.makeConstraints { make in
        make.height.equalTo(44.0)
        make.width.equalToSuperview()
      }
      let label = UILabel()
      label.text = reason
      view.addSubview(label)
      label.snp.makeConstraints { make in
        make.left.equalToSuperview().inset(16)
        make.centerY.equalToSuperview()
      }
      let div = UIView()
      div.backgroundColor = c().softBackground.ui
      view.addSubview(div)
      div.snp.makeConstraints { make in
        make.bottom.equalToSuperview()
        make.horizontalEdges.equalToSuperview().inset(8.0)
        make.height.equalTo(1)
      }
      let right = UIImageView(image: UIImage(systemName: "chevron.right"))
      view.addSubview(right)
      right.snp.makeConstraints { make in
        make.right.equalToSuperview().inset(16.0)
        make.centerY.equalToSuperview()
      }
      view.tag = index
      view.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(tapReason)))
    }
    label.text = "Why are you reporting this \(entity)?"
  }
  
  var onSubmit:() -> Void = {}
  
  @objc func tapReason(_ sender: UITapGestureRecognizer) {
    let reason = reasons[sender.view?.tag ?? 0]
    message?.flag(reason)
    user?.flag(reason)
    chat?.flag(reason)
    onSubmit()
  }
}
