//
//  Threads.swift
//  BotStacksChat
//
//  Created by Zaid Daghestani on 2/1/23.
//

import Foundation

func sortThreads(a: Chat, b: Chat) -> Bool {
  if let al = a.latestMessage, let bl = b.latestMessage {
    return al.createdAt > bl.createdAt
  } else if a.latestMessage != nil {
    return true
  } else if b.latestMessage != nil {
    return false
  } else {
    return a.displayName > b.displayName
  }
}

func sortNetworkThreads(a: Chat, b: Chat) -> Bool {
  if a.hasInvite && !b.hasInvite {
    return true
  }
  if b.hasInvite {
    return false
  }
  return a.activeMembers.count > b.activeMembers.count
}

func sortMessages(a: Message, b: Message) -> Bool {
  return a.createdAt > b.createdAt
}
