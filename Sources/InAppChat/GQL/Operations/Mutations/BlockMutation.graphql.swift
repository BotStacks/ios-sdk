// @generated
// This file was automatically generated and should not be edited.

@_exported import Apollo

public extension Gql {
  class BlockMutation: GraphQLMutation {
    public static let operationName: String = "Block"
    public static let document: Apollo.DocumentType = .notPersisted(
      definition: .init(
        #"""
        mutation Block($user: ID!) {
          block(user: $user)
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
        .field("block", Bool.self, arguments: ["user": .variable("user")]),
      ] }

      /// Blocks a User for the current User
      public var block: Bool { __data["block"] }
    }
  }

}