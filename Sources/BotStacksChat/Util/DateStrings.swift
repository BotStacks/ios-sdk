//
//  DateStrings.swift
//  BotStacksChat
//
//  Created by Zaid Daghestani on 2/1/23.
//

import Foundation
import SwiftDate

extension Date {
  func toSimpleTime() -> String {
    return self.toString(.time(.short))
  }

  func lastSeen() -> String {
    if isToday {
      return "Last seen today " + toSimpleTime()
    } else if isYesterday {
      return "Last seen yesterday " + toSimpleTime()
    } else {
      return timeAgo()
    }
  }

  func timeAgo() -> String {
    return self.toRelative(since: nil, dateTimeStyle: .numeric, unitsStyle: .abbreviated)
  }
}
