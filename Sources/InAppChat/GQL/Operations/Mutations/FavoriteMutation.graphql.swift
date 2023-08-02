// @generated
// This file was automatically generated and should not be edited.

@_exported import Apollo

public extension Gql {
  class FavoriteMutation: GraphQLMutation {
    public static let operationName: String = "Favorite"
    public static let operationDocument: Apollo.OperationDocument = .init(
      definition: .init(
        #"mutation Favorite($message: ID!) { favorite(id: $message) }"#
      ))

    public var message: ID

    public init(message: ID) {
      self.message = message
    }

    public var __variables: Variables? { ["message": message] }

    public struct Data: Gql.SelectionSet {
      public let __data: DataDict
      public init(_dataDict: DataDict) { __data = _dataDict }

      public static var __parentType: Apollo.ParentType { Gql.Objects.Mutation }
      public static var __selections: [Apollo.Selection] { [
        .field("favorite", Bool.self, arguments: ["id": .variable("message")]),
      ] }

      /// Favorite a Message as the current User
      public var favorite: Bool { __data["favorite"] }
    }
  }

}