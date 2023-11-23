// @generated
// This file was automatically generated and should not be edited.

@_exported import Apollo

public extension Gql {
  class ListUsersQuery: GraphQLQuery {
    public static let operationName: String = "ListUsers"
    public static let operationDocument: Apollo.OperationDocument = .init(
      definition: .init(
        #"query ListUsers($count: Int, $offset: Int) { users(count: $count, offset: $offset) { __typename ...FUser } }"#,
        fragments: [FUser.self, FDevice.self]
      ))

    public var count: GraphQLNullable<Int>
    public var offset: GraphQLNullable<Int>

    public init(
      count: GraphQLNullable<Int>,
      offset: GraphQLNullable<Int>
    ) {
      self.count = count
      self.offset = offset
    }

    public var __variables: Variables? { [
      "count": count,
      "offset": offset
    ] }

    public struct Data: Gql.SelectionSet {
      public let __data: DataDict
      public init(_dataDict: DataDict) { __data = _dataDict }

      public static var __parentType: Apollo.ParentType { Gql.Objects.Query }
      public static var __selections: [Apollo.Selection] { [
        .field("users", [User].self, arguments: [
          "count": .variable("count"),
          "offset": .variable("offset")
        ]),
      ] }

      /// Retrieves Users in the current Chat silo
      public var users: [User] { __data["users"] }

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
    }
  }

}