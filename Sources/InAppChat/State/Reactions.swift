//
//  Reactions.swift
//  InAppChat
//
//  Created by Zaid Daghestani on 6/28/23.
//

import Foundation

public typealias Reactions = [(reaction: String, uids: [String])]

func parseReactions(reactions: String?) -> Reactions? {
  guard let reactions = reactions else {
    return nil
  }
  return reactions.split(separator: ";").compactMap { reaction in
    let [head, tail] = reaction.split(separator: ":")
    return (reaction: head, uids: tail.split(","))
  }
}

func addReaction(reactions: inout Reactions, uid: String, reaction: String) {
  if var r = reactions.first(where: {$0.reaction == reaction}) {
    r.uids.append(uid)
  } else {
    reactions.append((reaction: reaction, uids: [uid]))
  }
}

func removeReaction(reactions: inout Reactions, index: UInt, uid: String) {
  reactions[index].uids = reactions[index].uids.filter { $0 !== uid }
  if reactions[index].uids.isEmpty {
    reactions.remove(at: index)
  }
}

func findUserReactionIndex(_ reactions:Reactions, _ uid: String) -> UInt {
  return reactions.first(where: {$0.uids.contains(uid)})
}

enum Change: String {
  case add = "add"
  case delete = "delete"
  case change = "change"
}

func react(
  uid: String,
  reaction: String,
  reactions: Reactions
) -> Change {
  let index = findUserReactionIndex(reactions, uid);
  if (index > -1) {
    if (reaction === reactions[index][0]) {
      removeReaction(reactions, index, uid);
      return Change.delete;
    } else {
      removeReaction(reactions, index, uid);
      addReaction(reactions, uid, reaction);
      return Change.change;
    }
  } else {
    addReaction(reactions, uid, reaction);
    return Change.add;
  }
}
