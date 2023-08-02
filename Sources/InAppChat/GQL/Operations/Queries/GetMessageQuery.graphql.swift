// @generated
// This file was automatically generated and should not be edited.

@_exported import Apollo

public extension Gql {
  class GetMessageQuery: GraphQLQuery {
    public static let operationName: String = "GetMessage"
    public static let operationDocument: Apollo.OperationDocument = .init(
      definition: .init(
        #"query GetMessage($id: ID!) { message(id: $id) { __typename ...FMessage } }"#,
        fragments: [FMessage.self, FUser.self, FDevice.self]
      ))

    public var id: ID

    public init(id: ID) {
      self.id = id
    }

    public var __variables: Variables? { ["id": id] }

    public struct Data: Gql.SelectionSet {
      public let __data: DataDict
      public init(_dataDict: DataDict) { __data = _dataDict }

      public static var __parentType: Apollo.ParentType { Gql.Objects.Query }
      public static var __selections: [Apollo.Selection] { [
        .field("message", Message?.self, arguments: ["id": .variable("id")]),
      ] }

      /// Fetch a Message by ID
      public var message: Message? { __data["message"] }

      /// Message
      ///
      /// Parent Type: `Message`
      public struct Message: Gql.SelectionSet {
        public let __data: DataDict
        public init(_dataDict: DataDict) { __data = _dataDict }

        public static var __parentType: Apollo.ParentType { Gql.Objects.Message }
        public static var __selections: [Apollo.Selection] { [
          .field("__typename", String.self),
          .fragment(FMessage.self),
        ] }

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

        /// Message.User
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

          /// Message.User.Device
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