//
//  Settings.swift
//  InAppChat
//
//  Created by Zaid Daghestani on 2/1/23.
//

import Foundation

public typealias NotificationSetting = Gql.NotificationSetting
public typealias OnlineStatus = Gql.OnlineStatus
public class Settings: ObservableObject {
  
  @Published var notifications = NotificationSetting(
    rawValue: UserDefaults.standard.string(forKey: "iac.notifications") ?? "all")!

  @Published var availability = OnlineStatus(
    rawValue: UserDefaults.standard.string(forKey: "iac.availability") ?? "Online")

  @Published var blocked: [String] = UserDefaults.standard.stringArray(forKey: "iac.blocked") ?? []

  public func setNotification(_ setting: NotificationSetting, isSync: Bool = false) {
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

  public func setAvailability(_ availability: OnlineStatus, isSync: Bool = false) {
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
