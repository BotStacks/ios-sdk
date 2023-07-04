// @generated
// This file was automatically generated and should not be edited.

import Apollo

public extension Gql {
  /// The available fields for updating on the current User's profile
  struct UpdateProfileInput: InputObject {
    public private(set) var __data: InputDict

    public init(_ data: InputDict) {
      __data = data
    }

    public init(
      display_name: GraphQLNullable<String> = nil,
      image: GraphQLNullable<String> = nil,
      notification_setting: GraphQLNullable<GraphQLEnum<NotificationSetting>> = nil,
      status: GraphQLNullable<GraphQLEnum<OnlineStatus>> = nil,
      username: GraphQLNullable<String> = nil
    ) {
      __data = InputDict([
        "display_name": display_name,
        "image": image,
        "notification_setting": notification_setting,
        "status": status,
        "username": username
      ])
    }

    /// The User's desired new display name
    public var display_name: GraphQLNullable<String> {
      get { __data["display_name"] }
      set { __data["display_name"] = newValue }
    }

    /// The User's desired new image
    public var image: GraphQLNullable<String> {
      get { __data["image"] }
      set { __data["image"] = newValue }
    }

    /// Notifications
    public var notification_setting: GraphQLNullable<GraphQLEnum<NotificationSetting>> {
      get { __data["notification_setting"] }
      set { __data["notification_setting"] = newValue }
    }

    /// The User's desired new online status
    public var status: GraphQLNullable<GraphQLEnum<OnlineStatus>> {
      get { __data["status"] }
      set { __data["status"] = newValue }
    }

    /// The User's desired new username
    public var username: GraphQLNullable<String> {
      get { __data["username"] }
      set { __data["username"] = newValue }
    }
  }

}