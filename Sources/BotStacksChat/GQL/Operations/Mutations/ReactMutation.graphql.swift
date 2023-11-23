// @generated
// This file was automatically generated and should not be edited.

@_exported import Apollo

public extension Gql {
  class ReactMutation: GraphQLMutation {
    public static let operationName: String = "React"
    public static let operationDocument: Apollo.OperationDocument = .init(
      definition: .init(
        #"mutation React($id: ID!, $reaction: String) { react(id: $id, reaction: $reaction) }"#
      ))

    public var id: ID
    public var reaction: GraphQLNullable<String>

    public init(
      id: ID,
      reaction: GraphQLNullable<String>
    ) {
      self.id = id
      self.reaction = reaction
    }

    public var __variables: Variables? { [
      "id": id,
      "reaction": reaction
    ] }

    public struct Data: Gql.SelectionSet {
      public let __data: DataDict
      public init(_dataDict: DataDict) { __data = _dataDict }

      public static var __parentType: Apollo.ParentType { Gql.Objects.Mutation }
      public static var __selections: [Apollo.Selection] { [
        .field("react", Bool.self, arguments: [
          "id": .variable("id"),
          "reaction": .variable("reaction")
        ]),
      ] }

      /// React to a Message as the current User. If no reaction is passed, the reaction for the current User is removed.
      public var react: Bool { __data["react"] }
    }
  }

}