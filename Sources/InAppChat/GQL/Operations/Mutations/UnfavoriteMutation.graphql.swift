// @generated
// This file was automatically generated and should not be edited.

@_exported import Apollo

public extension Gql {
  class UnfavoriteMutation: GraphQLMutation {
    public static let operationName: String = "Unfavorite"
    public static let document: Apollo.DocumentType = .notPersisted(
      definition: .init(
        #"""
        mutation Unfavorite($message: ID!) {
          unfavorite(id: $message)
        }
        """#
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
        .field("unfavorite", Bool.self, arguments: ["id": .variable("message")]),
      ] }

      /// Unfavorite a Message as the current User
      public var unfavorite: Bool { __data["unfavorite"] }
    }
  }

}