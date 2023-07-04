// @generated
// This file was automatically generated and should not be edited.

@_exported import Apollo

public extension Gql {
  class SetNotificationSettingMutation: GraphQLMutation {
    public static let operationName: String = "SetNotificationSetting"
    public static let document: Apollo.DocumentType = .notPersisted(
      definition: .init(
        #"""
        mutation SetNotificationSetting($chat: ID!, $setting: NotificationSetting!) {
          setNotificationSetting(chat: $chat, setting: $setting)
        }
        """#
      ))

    public var chat: ID
    public var setting: GraphQLEnum<NotificationSetting>

    public init(
      chat: ID,
      setting: GraphQLEnum<NotificationSetting>
    ) {
      self.chat = chat
      self.setting = setting
    }

    public var __variables: Variables? { [
      "chat": chat,
      "setting": setting
    ] }

    public struct Data: Gql.SelectionSet {
      public let __data: DataDict
      public init(_dataDict: DataDict) { __data = _dataDict }

      public static var __parentType: Apollo.ParentType { Gql.Objects.Mutation }
      public static var __selections: [Apollo.Selection] { [
        .field("setNotificationSetting", Bool.self, arguments: [
          "chat": .variable("chat"),
          "setting": .variable("setting")
        ]),
      ] }

      /// Set the notification setting for the current User in this chat
      public var setNotificationSetting: Bool { __data["setNotificationSetting"] }
    }
  }

}