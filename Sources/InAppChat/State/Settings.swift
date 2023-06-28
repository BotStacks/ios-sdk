//
//  Settings.swift
//  InAppChat
//
//  Created by Zaid Daghestani on 2/1/23.
//

import Foundation

public class Settings: ObservableObject {
  
  public enum Notifications: String {
    case all = "all"
    case mentions = "mentions"
    case none = "none"
  }

  @Published var notifications = Notifications.init(
    rawValue: UserDefaults.standard.string(forKey: "iac.notifications") ?? "all")!

  @Published var availability = Gql.OnlineStatus(
    rawValue: UserDefaults.standard.string(forKey: "iac.availability") ?? "Online")

  @Published var blocked: [String] = UserDefaults.standard.stringArray(forKey: "iac.blocked") ?? []

  public func setNotification(_ setting: Settings.Notifications, isSync: Bool = false) {
    self.notifications = setting
    UserDefaults.standard.setValue(setting.rawValue, forKey: "iac.notifications")
    if isSync { return }
    Task.detached {
      do {
        try await api.updateSetting(notifications: setting)
      } catch let err {
        Monitoring.error(err)
      }
    }
  }

  public func setAvailability(_ availability: Gql.OnlineStatus, isSync: Bool = false) {
    self.availability = availability
    UserDefaults.standard.set(availability.rawValue, forKey: "iac.availability")
    if isSync {
      return
    }
    Task.detached {
      do {
        try await api.update(availability: availability)
      } catch let err {
        Monitoring.error(err)
      }
    }
  }

  public func setBlock(_ uid: String, _ blocked: Bool) {
    if blocked {
      if !self.blocked.contains(uid) {
        self.blocked.append(uid)
        UserDefaults.standard.set(self.blocked, forKey: "iac.blocked")
      }
    } else {
      self.blocked.remove(element: uid)
      UserDefaults.standard.set(self.blocked, forKey: "iac.blocked")
    }
  }
}
