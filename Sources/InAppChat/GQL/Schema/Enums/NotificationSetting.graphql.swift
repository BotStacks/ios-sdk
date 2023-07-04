// @generated
// This file was automatically generated and should not be edited.

import Apollo

public extension Gql {
  /// Notification setting for a user, can be set per chat
  enum NotificationSetting: String, EnumType {
    /// Allow all notifications, mentions and dms
    case all = "all"
    /// Allow only mention notifictions
    case mentions = "mentions"
    /// No notifications
    case none = "none"
  }

}