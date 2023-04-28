//
//  Threads.swift
//  InAppChat
//
//  Created by Zaid Daghestani on 2/1/23.
//

import Foundation

func sortThreads(a: Thread, b: Thread) -> Bool {
  if let al = a.latest, let bl = b.latest {
    return al.createdAt > bl.createdAt
  } else if a.latest != nil {
    return true
  } else if b.latest != nil {
    return false
  } else {
    return a.name > b.name
  }
}

func sortNetworkThreads(a: Thread, b: Thread) -> Bool {
  if let ag = a.group, let bg = b.group {
    if ag.hasInvite && !bg.hasInvite {
      return true
    }
    if bg.hasInvite {
      return false
    }
    return ag.participants.count > bg.participants.count
  }
  if let al = a.latest, let bl = b.latest {
    return al.createdAt > bl.createdAt
  } else if a.latest != nil {
    return true
  } else if b.latest != nil {
    return false
  } else {
    return a.name > b.name
  }
}

func sortMessages(a: Message, b: Message) -> Bool {
  return a.createdAt > b.createdAt
}
