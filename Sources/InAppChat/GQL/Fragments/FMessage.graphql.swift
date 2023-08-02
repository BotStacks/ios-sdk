// @generated
// This file was automatically generated and should not be edited.

@_exported import Apollo

public extension Gql {
  struct FMessage: Gql.SelectionSet, Fragment {
    public static var fragmentDefinition: StaticString {
      "fragment FMessage on Message { __typename id system created_at updated_at text parent_id reply_count reactions chat_id user { __typename ...FUser } attachments { __typename id type url data mime width height duration address latitude longitude } mentions { __typename user_id username offset } }"
    }

    public let __data: DataDict
    public init(_dataDict: DataDict) { __data = _dataDict }

    public static var __parentType: Apollo.ParentType { Gql.Objects.Message }
    public static var __selections: [Apollo.Selection] { [
      .field("__typename", String.self),
      .field("id", Gql.ID.self),
      .field("system", GraphQLEnum<Gql.SystemMessageType>?.self),
      .field("created_at", Gql.DateTime.self),
      .field("updated_at", Gql.DateTime.self),
      .field("text", String?.self),
      .field("parent_id", String?.self),
      .field("reply_count", Int.self),
      .field("reactions", String?.self),
      .field("chat_id", String.self),
      .field("user", User.self),
      .field("attachments", [Attachment]?.self),
      .field("mentions", [Mention]?.self),
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
    public var attachments: [Attachment]? { __data["attachments"] }
    /// The mentions in the message
    public var mentions: [Mention]? { __data["mentions"] }

    /// User
    ///
    /// Parent Type: `User`
    public struct User: Gql.SelectionSet {
      public let __data: DataDict
      public init(_dataDict: DataDict) { __data = _dataDict }

      public static var __parentType: Apollo.ParentType { Gql.Objects.User }
      public static var __selections: [Apollo.Selection] { [
        .field("__typename", String.self),
        .fragment(FUser.self),
      ] }

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

      /// User.Device
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

    /// Attachment
    ///
    /// Parent Type: `Attachment`
    public struct Attachment: Gql.SelectionSet {
      public let __data: DataDict
      public init(_dataDict: DataDict) { __data = _dataDict }

      public static var __parentType: Apollo.ParentType { Gql.Objects.Attachment }
      public static var __selections: [Apollo.Selection] { [
        .field("__typename", String.self),
        .field("id", Gql.ID.self),
        .field("type", GraphQLEnum<Gql.AttachmentType>.self),
        .field("url", String.self),
        .field("data", String?.self),
        .field("mime", String?.self),
        .field("width", Int?.self),
        .field("height", Int?.self),
        .field("duration", Int?.self),
        .field("address", String?.self),
        .field("latitude", Gql.Latitude?.self),
        .field("longitude", Gql.Longitude?.self),
      ] }

      /// The ID of the Attachment
      public var id: Gql.ID { __data["id"] }
      /// The type of the Attachment
      public var type: GraphQLEnum<Gql.AttachmentType> { __data["type"] }
      /// The url of the file or 'data' if an arbitrary object
      public var url: String { __data["url"] }
      /// The raw data of the Attachment if it is a VCard
      public var data: String? { __data["data"] }
      /// The mime type of the attachment if it is a file, image, video or audio object
      public var mime: String? { __data["mime"] }
      /// The width of the image or video in integer pixels
      public var width: Int? { __data["width"] }
      /// The height of the image or video in integer pixels
      public var height: Int? { __data["height"] }
      /// The duration of the audio or video in seconds
      public var duration: Int? { __data["duration"] }
      /// The address of the location
      public var address: String? { __data["address"] }
      /// The latitude of the location
      public var latitude: Gql.Latitude? { __data["latitude"] }
      /// The longitude of the location
      public var longitude: Gql.Longitude? { __data["longitude"] }
    }

    /// Mention
    ///
    /// Parent Type: `Mention`
    public struct Mention: Gql.SelectionSet {
      public let __data: DataDict
      public init(_dataDict: DataDict) { __data = _dataDict }

      public static var __parentType: Apollo.ParentType { Gql.Objects.Mention }
      public static var __selections: [Apollo.Selection] { [
        .field("__typename", String.self),
        .field("user_id", Gql.ID.self),
        .field("username", String.self),
        .field("offset", Int.self),
      ] }

      /// The ID of the user mentioned
      public var user_id: Gql.ID { __data["user_id"] }
      /// The username of the user mentioned
      public var username: String { __data["username"] }
      /// The position of the offset in the text
      public var offset: Int { __data["offset"] }
    }
  }

}