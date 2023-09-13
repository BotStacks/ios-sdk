//
//  Events.swift
//  InAppChat
//
//  Created by Zaid Daghestani on 6/28/23.
//

import Foundation


extension InAppChatStore {
  
  func onCoreEvent(_ event: Gql.CoreSubscription.Data.Core) {
    print("Got Core Event \(event.__typename)")
    if let del = event.asDeleteEvent {
      switch del.kind {
      case .case(let entity):
        switch entity {
        case .chat:
          if let chat = Chat.get(del.id) {
            if let membership = chat.membership {
              memberships.remove(element: membership)
            }
            network.items.remove(element: chat)
            cache.chats.removeValue(forKey: chat.id)
            if chat.isDM, let uid = chat.friend?.id {
              cache.chatsByUID.removeValue(forKey: uid)
            }
          }
          break
        case .device:
          
          break
        case .message:
          if let message = Message.get(del.id) {
            cache.messages.removeValue(forKey: del.id)
            message.chat.items.remove(element: message)
            favorites.items.remove(element: message)
          }
          break
        case .user:
          
          break
        }
      default:
        print("Unknown delete type \(del.kind.rawValue)")
      }
    } else if let it = event.asEntityEvent {
      let isUpdate = it.type.rawValue == "Update"
      if let raw = it.entity.asUser {
        let user = User.get(.init(_dataDict: raw.__data))
        contacts.items.append(user)
      } else if let raw = it.entity.asChat {
        let _chat = Gql.FChat(_dataDict: raw.__data)
        let chat = Chat.get(_chat)
      } else if let raw = it.entity.asMember, let chat = Chat.get(raw.chat_id) {
        let member = Member.fromGql(.init(_dataDict: raw.__data))
        if let index = chat.members.firstIndex(where: {$0.user_id == member.user_id}) {
          chat.members[index] = member
        } else {
          chat.members.append(member)
        }
      } else if let raw = it.entity.asMessage, let chat = Chat.get(raw.chat_id) {
        let message = Message.get(.init(_dataDict: raw.__data))
        if !isUpdate, !chat.items.contains(where: {$0.id == message.id}) {
          chat.items.insert(message, at: 0)
          chat.sending.removeAll(where: {$0.id == message.id})
        }
        if !isUpdate && (chat.latestMessage == nil || chat.latestMessage!.createdAt < message.createdAt) {
          chat.latestMessage = message
        }
        if isUpdate {
          chat.sub.send(message.id)
        } else {
          if Chat.current != chat.id {
            chat.unreadCount += 1
          }
        }
      }
    }
  }
  
  func onMeEvent(_ event: Gql.MeSubscription.Data.Me) {
    print("Got Me Event \(event.__typename)")
    if let invite = event.asInviteEvent {
      let chat = Chat.get(.init(_dataDict: invite.to.__data))
      let by = User.get(.init(_dataDict: invite.by.__data))
      chat.invites.insert(by)
    } else if let reactions = event.asReactionEvent {
      let _ = Message.get(.init(_dataDict: reactions.message.__data))
    } else if let reply = event.asReplyEvent {
      let _ = Message.get(.init(_dataDict: reply.__data))
    }
  }
  
}
