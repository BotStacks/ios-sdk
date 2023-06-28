// @generated
// This file was automatically generated and should not be edited.

@_exported import Apollo

public extension Gql {
  class JoinChatMutation: GraphQLMutation {
    public static let operationName: String = "JoinChat"
    public static let document: Apollo.DocumentType = .notPersisted(
      definition: .init(
        #"""
        mutation JoinChat($id: ID!) {
          join(chat: $id) {
            __typename
            role
            created_at
            updated_at
            last_read_at
          }
        }
        """#
      ))

    public var id: ID

    public init(id: ID) {
      self.id = id
    }

    public var __variables: Variables? { ["id": id] }

    public struct Data: Gql.SelectionSet {
      public let __data: DataDict
      public init(_dataDict: DataDict) { __data = _dataDict }

      public static var __parentType: Apollo.ParentType { Gql.Objects.Mutation }
      public static var __selections: [Apollo.Selection] { [
        .field("join", Join?.self, arguments: ["chat": .variable("id")]),
      ] }

      /// Joins a Chat. Always succeeds if that Chat is public and the user hasn't been Kicked.
      /// If the Chat is private, success only occurs if the User has been invited.
      public var join: Join? { __data["join"] }

      /// Join
      ///
      /// Parent Type: `Member`
      public struct Join: Gql.SelectionSet {
        public let __data: DataDict
        public init(_dataDict: DataDict) { __data = _dataDict }

        public static var __parentType: Apollo.ParentType { Gql.Objects.Member }
        public static var __selections: [Apollo.Selection] { [
          .field("__typename", String.self),
          .field("role", GraphQLEnum<Gql.MemberRole>.self),
          .field("created_at", Gql.DateTime.self),
          .field("updated_at", Gql.DateTime.self),
          .field("last_read_at", Gql.DateTime.self),
        ] }

        /// THe Role of the Member in the Chat
        public var role: GraphQLEnum<Gql.MemberRole> { __data["role"] }
        /// The creation date of the membership
        public var created_at: Gql.DateTime { __data["created_at"] }
        /// The updated date of the Chat
        public var updated_at: Gql.DateTime { __data["updated_at"] }
        /// The date the Member last read the Chat. Maintained in order to provide unread statuses of Chats
        public var last_read_at: Gql.DateTime { __data["last_read_at"] }
      }
    }
  }

}