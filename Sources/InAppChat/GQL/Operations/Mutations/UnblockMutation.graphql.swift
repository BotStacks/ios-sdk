// @generated
// This file was automatically generated and should not be edited.

@_exported import Apollo

public extension Gql {
  class UnblockMutation: GraphQLMutation {
    public static let operationName: String = "Unblock"
    public static let document: Apollo.DocumentType = .notPersisted(
      definition: .init(
        #"""
        mutation Unblock($user: ID!) {
          unblock(user: $user)
        }
        """#
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
        .field("unblock", Bool?.self, arguments: ["user": .variable("user")]),
      ] }

      /// Unblocks a User for the current User
      public var unblock: Bool? { __data["unblock"] }
    }
  }

}