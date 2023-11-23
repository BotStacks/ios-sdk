//
//  Reactions.swift
//  BotStacksChat
//
//  Created by Zaid Daghestani on 6/28/23.
//

import Foundation

public typealias Reactions = [(reaction: String, uids: [String])]

func parseReactions(reactions: String?) -> Reactions? {
  guard let _reactions = reactions else {
    return nil
  }
  return _reactions.split(separator: ";").map { reaction in
    let split = reaction.split(separator: ":")
    return (reaction: String(split[0]), uids: split[1].split(separator: ",").map({String($0)}))
  }
}

func addReaction(_ reactions: inout Reactions, _ uid: String, _ reaction: String) {
  if var r = reactions.first(where: {$0.reaction == reaction}) {
    r.uids.append(uid)
  } else {
    reactions.append((reaction: reaction, uids: [uid]))
  }
}

func removeReaction(_ reactions: inout Reactions, _ index: Int, _ uid: String) {
  reactions[index].uids = reactions[index].uids.filter { $0 != uid }
  if reactions[index].uids.isEmpty {
    reactions.remove(at: index)
  }
}

func findUserReactionIndex(_ reactions:Reactions, _ uid: String) -> Int? {
  return reactions.firstIndex(where: {$0.uids.contains(uid)})
}

enum Change: String {
  case add = "add"
  case delete = "delete"
  case change = "change"
}

func react_impl(
  uid: String,
  reaction: String,
  reactions: inout Reactions
) -> Change {
  let index = findUserReactionIndex(reactions, uid);
  if let index = index {
    if (reaction == reactions[index].reaction) {
      removeReaction(&reactions, index, uid);
      return Change.delete;
    } else {
      removeReaction(&reactions, index, uid);
      addReaction(&reactions, uid, reaction);
      return Change.change;
    }
  } else {
    addReaction(&reactions, uid, reaction);
    return Change.add;
  }
}
