// @generated
// This file was automatically generated and should not be edited.

@_exported import Apollo

public extension Gql {
  class DMMutation: GraphQLMutation {
    public static let operationName: String = "DM"
    public static let operationDocument: Apollo.OperationDocument = .init(
      definition: .init(
        #"mutation DM($user: ID!) { dm(user: $user) { __typename ...FMember chat { __typename ...FChat } } }"#,
        fragments: [FMember.self, FUser.self, FDevice.self, FChat.self, FMessage.self]
      ))

    public var user: ID

    public init(user: ID) {
      self.user = user
    }

    public var __variables: Variables? { ["user": user] }

    public struct Data: Gql.SelectionSet {
      public let __data: DataDict
      public init(_dataDict: DataDict) { __data = _dataDict }

      public static var __parentType: Apollo.ParentType { Gql.Objects.Mutation }
      public static var __selections: [Apollo.Selection] { [
        .field("dm", Dm?.self, arguments: ["user": .variable("user")]),
      ] }

      /// Start a directmessage Chat with a User
      public var dm: Dm? { __data["dm"] }

      /// Dm
      ///
      /// Parent Type: `Member`
      public struct Dm: Gql.SelectionSet {
        public let __data: DataDict
        public init(_dataDict: DataDict) { __data = _dataDict }

        public static var __parentType: Apollo.ParentType { Gql.Objects.Member }
        public static var __selections: [Apollo.Selection] { [
          .field("__typename", String.self),
          .field("chat", Chat.self),
          .fragment(FMember.self),
        ] }

        /// The Chat the Member belongs to
        public var chat: Chat { __data["chat"] }
        /// THe Role of the Member in the Chat
        public var role: GraphQLEnum<Gql.MemberRole> { __data["role"] }
        /// The creation date of the membership
        public var created_at: Gql.DateTime { __data["created_at"] }
        /// The User the Member represents
        public var user: User { __data["user"] }
        /// The ID of the Chat the Member belongs to
        public var chat_id: String { __data["chat_id"] }

        public struct Fragments: FragmentContainer {
          public let __data: DataDict
          public init(_dataDict: DataDict) { __data = _dataDict }

          public var fMember: FMember { _toFragment() }
        }

        /// Dm.Chat
        ///
        /// Parent Type: `Chat`
        public struct Chat: Gql.SelectionSet {
          public let __data: DataDict
          public init(_dataDict: DataDict) { __data = _dataDict }

          public static var __parentType: Apollo.ParentType { Gql.Objects.Chat }
          public static var __selections: [Apollo.Selection] { [
            .field("__typename", String.self),
            .fragment(FChat.self),
          ] }

          /// The ID of this Chat
          public var id: Gql.ID { __data["id"] }
          /// The type of chat. Available types are DirectMessage, Group, Conversation and Thread.
          public var kind: GraphQLEnum<Gql.ChatType> { __data["kind"] }
          /// The creation date of this Chat
          public var created_at: Gql.DateTime { __data["created_at"] }
          /// The update date of this Chat
          public var updated_at: Gql.DateTime { __data["updated_at"] }
          /// The name of the group chat
          public var name: String? { __data["name"] }
          /// The description of the group caht
          public var description: String? { __data["description"] }
          /// THe image associated with the group chat
          public var image: String? { __data["image"] }
          /// Whether the chat can be joined by outside Users
          public var _private: Bool { __data["_private"] }
          /// Whether or not the chat is encrypted
          public var encrypted: Bool { __data["encrypted"] }
          /// The number of unread messages for the current User in this Chat
          public var unread_count: Int { __data["unread_count"] }
          /// The members in this group Chat
          public var members: [Member] { __data["members"] }
          /// The most recent message sent to this chat if unencrypted
          public var last_message: Last_message? { __data["last_message"] }
          /// The current user's notification settings for this chat
          public var notification_setting: GraphQLEnum<Gql.NotificationSetting>? { __data["notification_setting"] }

          public struct Fragments: FragmentContainer {
            public let __data: DataDict
            public init(_dataDict: DataDict) { __data = _dataDict }

            public var fChat: FChat { _toFragment() }
          }

          /// Dm.Chat.Member
          ///
          /// Parent Type: `Member`
          public struct Member: Gql.SelectionSet {
            public let __data: DataDict
            public init(_dataDict: DataDict) { __data = _dataDict }

            public static var __parentType: Apollo.ParentType { Gql.Objects.Member }

            /// THe Role of the Member in the Chat
            public var role: GraphQLEnum<Gql.MemberRole> { __data["role"] }
            /// The creation date of the membership
            public var created_at: Gql.DateTime { __data["created_at"] }
            /// The User the Member represents
            public var user: User { __data["user"] }
            /// The ID of the Chat the Member belongs to
            public var chat_id: String { __data["chat_id"] }

            public struct Fragments: FragmentContainer {
              public let __data: DataDict
              public init(_dataDict: DataDict) { __data = _dataDict }

              public var fMember: FMember { _toFragment() }
            }

            /// Dm.Chat.Member.User
            ///
            /// Parent Type: `User`
            public struct User: Gql.SelectionSet {
              public let __data: DataDict
              public init(_dataDict: DataDict) { __data = _dataDict }

              public static var __parentType: Apollo.ParentType { Gql.Objects.User }

              /// The ID of the User
              public var id: Gql.ID { __data["id"] }
              /// The date this User was updated
              public var updated_at: Gql.DateTime { __data["updated_at"] }
              /// The date this User was created
              public var created_at: Gql.DateTime { __data["created_at"] }
              /// Last seen date of the user
              public var last_seen: Gql.DateTime { __data["last_seen"] }
              /// This User's unique handle. Can be alphanumeric and "_"
              public var username: String { __data["username"] }
              /// A freeform display name for a user. Can contain emojis
              public var display_name: String? { __data["display_name"] }
              /// The User's bio or profile description
              public var description: String? { __data["description"] }
              /// The image associated with the User
              public var image: String? { __data["image"] }
              /// Whether or not this user is an AI bot
              public var is_bot: Bool? { __data["is_bot"] }
              /// The online status of this user
              public var status: GraphQLEnum<Gql.OnlineStatus> { __data["status"] }
              /// The Role of this User in their primary App
              public var app_role: GraphQLEnum<Gql.AppUserRole> { __data["app_role"] }
              /// The User's devices
              public var devices: [Device] { __data["devices"] }

              public struct Fragments: FragmentContainer {
                public let __data: DataDict
                public init(_dataDict: DataDict) { __data = _dataDict }

                public var fUser: FUser { _toFragment() }
              }

              /// Dm.Chat.Member.User.Device
              ///
              /// Parent Type: `Device`
              public struct Device: Gql.SelectionSet {
                public let __data: DataDict
                public init(_dataDict: DataDict) { __data = _dataDict }

                public static var __parentType: Apollo.ParentType { Gql.Objects.Device }

                /// The Device's ID as provided by the Device
                public var id: Gql.ID { __data["id"] }
                /// The date this Device was created
                public var created_at: Gql.DateTime { __data["created_at"] }
                /// The date this Device was updated
                public var updated_at: Gql.DateTime { __data["updated_at"] }
                /// The Device's Identity Key
                public var ik: String { __data["ik"] }
                /// The Device's Signed PreKey
                public var spk: String { __data["spk"] }
                /// The Device's PreKey Signature Sig(IK, Encode(SPK))
                public var pks: String { __data["pks"] }
                /// The Device's One Time PreKey Set
                public var opk: [String] { __data["opk"] }

                public struct Fragments: FragmentContainer {
                  public let __data: DataDict
                  public init(_dataDict: DataDict) { __data = _dataDict }

                  public var fDevice: FDevice { _toFragment() }
                }
              }
            }
          }

          /// Dm.Chat.Last_message
          ///
          /// Parent Type: `Message`
          public struct Last_message: Gql.SelectionSet {
            public let __data: DataDict
            public init(_dataDict: DataDict) { __data = _dataDict }

            public static var __parentType: Apollo.ParentType { Gql.Objects.Message }

            /// The ID of the Message
            public var id: Gql.ID { __data["id"] }
            /// System Messages are special messages that are not sent by Users
            /// if this is null it is not a system message
            /// if is filled, this is a system message of the specified type
            public var system: GraphQLEnum<Gql.SystemMessageType>? { __data["system"] }
            /// The creation date of the Message
            public var created_at: Gql.DateTime { __data["created_at"] }
            /// The updated date of the Message
            public var updated_at: Gql.DateTime { __data["updated_at"] }
            /// The text content of the Message. Can contain Markdown
            public var text: String? { __data["text"] }
            /// The ID of the Message this Message is in reply to if it is a reply
            public var parent_id: String? { __data["parent_id"] }
            /// The number of replies to this Message
            public var reply_count: Int { __data["reply_count"] }
            /// Reactions to the Message, string of the form reaction1:uid1,uid2...;reaction2:uid1,uid2...
            public var reactions: String? { __data["reactions"] }
            /// The ID of the Chat this message belongs to
            public var chat_id: String { __data["chat_id"] }
            /// The User that sent this Message
            public var user: User { __data["user"] }
            /// Attachments to the Message
            public var attachments: [FMessage.Attachment]? { __data["attachments"] }
            /// The mentions in the message
            public var mentions: [FMessage.Mention]? { __data["mentions"] }

            public struct Fragments: FragmentContainer {
              public let __data: DataDict
              public init(_dataDict: DataDict) { __data = _dataDict }

              public var fMessage: FMessage { _toFragment() }
            }

            /// Dm.Chat.Last_message.User
            ///
            /// Parent Type: `User`
            public struct User: Gql.SelectionSet {
              public let __data: DataDict
              public init(_dataDict: DataDict) { __data = _dataDict }

              public static var __parentType: Apollo.ParentType { Gql.Objects.User }

              /// The ID of the User
              public var id: Gql.ID { __data["id"] }
              /// The date this User was updated
              public var updated_at: Gql.DateTime { __data["updated_at"] }
              /// The date this User was created
              public var created_at: Gql.DateTime { __data["created_at"] }
              /// Last seen date of the user
              public var last_seen: Gql.DateTime { __data["last_seen"] }
              /// This User's unique handle. Can be alphanumeric and "_"
              public var username: String { __data["username"] }
              /// A freeform display name for a user. Can contain emojis
              public var display_name: String? { __data["display_name"] }
              /// The User's bio or profile description
              public var description: String? { __data["description"] }
              /// The image associated with the User
              public var image: String? { __data["image"] }
              /// Whether or not this user is an AI bot
              public var is_bot: Bool? { __data["is_bot"] }
              /// The online status of this user
              public var status: GraphQLEnum<Gql.OnlineStatus> { __data["status"] }
              /// The Role of this User in their primary App
              public var app_role: GraphQLEnum<Gql.AppUserRole> { __data["app_role"] }
              /// The User's devices
              public var devices: [Device] { __data["devices"] }

              public struct Fragments: FragmentContainer {
                public let __data: DataDict
                public init(_dataDict: DataDict) { __data = _dataDict }

                public var fUser: FUser { _toFragment() }
              }

              /// Dm.Chat.Last_message.User.Device
              ///
              /// Parent Type: `Device`
              public struct Device: Gql.SelectionSet {
                public let __data: DataDict
                public init(_dataDict: DataDict) { __data = _dataDict }

                public static var __parentType: Apollo.ParentType { Gql.Objects.Device }

                /// The Device's ID as provided by the Device
                public var id: Gql.ID { __data["id"] }
                /// The date this Device was created
                public var created_at: Gql.DateTime { __data["created_at"] }
                /// The date this Device was updated
                public var updated_at: Gql.DateTime { __data["updated_at"] }
                /// The Device's Identity Key
                public var ik: String { __data["ik"] }
                /// The Device's Signed PreKey
                public var spk: String { __data["spk"] }
                /// The Device's PreKey Signature Sig(IK, Encode(SPK))
                public var pks: String { __data["pks"] }
                /// The Device's One Time PreKey Set
                public var opk: [String] { __data["opk"] }

                public struct Fragments: FragmentContainer {
                  public let __data: DataDict
                  public init(_dataDict: DataDict) { __data = _dataDict }

                  public var fDevice: FDevice { _toFragment() }
                }
              }
            }
          }
        }
        /// Dm.User
        ///
        /// Parent Type: `User`
        public struct User: Gql.SelectionSet {
          public let __data: DataDict
          public init(_dataDict: DataDict) { __data = _dataDict }

          public static var __parentType: Apollo.ParentType { Gql.Objects.User }

          /// The ID of the User
          public var id: Gql.ID { __data["id"] }
          /// The date this User was updated
          public var updated_at: Gql.DateTime { __data["updated_at"] }
          /// The date this User was created
          public var created_at: Gql.DateTime { __data["created_at"] }
          /// Last seen date of the user
          public var last_seen: Gql.DateTime { __data["last_seen"] }
          /// This User's unique handle. Can be alphanumeric and "_"
          public var username: String { __data["username"] }
          /// A freeform display name for a user. Can contain emojis
          public var display_name: String? { __data["display_name"] }
          /// The User's bio or profile description
          public var description: String? { __data["description"] }
          /// The image associated with the User
          public var image: String? { __data["image"] }
          /// Whether or not this user is an AI bot
          public var is_bot: Bool? { __data["is_bot"] }
          /// The online status of this user
          public var status: GraphQLEnum<Gql.OnlineStatus> { __data["status"] }
          /// The Role of this User in their primary App
          public var app_role: GraphQLEnum<Gql.AppUserRole> { __data["app_role"] }
          /// The User's devices
          public var devices: [Device] { __data["devices"] }

          public struct Fragments: FragmentContainer {
            public let __data: DataDict
            public init(_dataDict: DataDict) { __data = _dataDict }

            public var fUser: FUser { _toFragment() }
          }

          /// Dm.User.Device
          ///
          /// Parent Type: `Device`
          public struct Device: Gql.SelectionSet {
            public let __data: DataDict
            public init(_dataDict: DataDict) { __data = _dataDict }

            public static var __parentType: Apollo.ParentType { Gql.Objects.Device }

            /// The Device's ID as provided by the Device
            public var id: Gql.ID { __data["id"] }
            /// The date this Device was created
            public var created_at: Gql.DateTime { __data["created_at"] }
            /// The date this Device was updated
            public var updated_at: Gql.DateTime { __data["updated_at"] }
            /// The Device's Identity Key
            public var ik: String { __data["ik"] }
            /// The Device's Signed PreKey
            public var spk: String { __data["spk"] }
            /// The Device's PreKey Signature Sig(IK, Encode(SPK))
            public var pks: String { __data["pks"] }
            /// The Device's One Time PreKey Set
            public var opk: [String] { __data["opk"] }

            public struct Fragments: FragmentContainer {
              public let __data: DataDict
              public init(_dataDict: DataDict) { __data = _dataDict }

              public var fDevice: FDevice { _toFragment() }
            }
          }
        }
      }
    }
  }

}