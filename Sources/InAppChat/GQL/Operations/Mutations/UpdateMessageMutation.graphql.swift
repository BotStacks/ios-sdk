// @generated
// This file was automatically generated and should not be edited.

@_exported import Apollo

public extension Gql {
  class UpdateMessageMutation: GraphQLMutation {
    public static let operationName: String = "UpdateMessage"
    public static let document: Apollo.DocumentType = .notPersisted(
      definition: .init(
        #"""
        mutation UpdateMessage($input: UpdateMessageInput!) {
          updateMessage(input: $input)
        }
        """#
      ))

    public var input: UpdateMessageInput

    public init(input: UpdateMessageInput) {
      self.input = input
    }

    public var __variables: Variables? { ["input": input] }

    public struct Data: Gql.SelectionSet {
      public let __data: DataDict
      public init(_dataDict: DataDict) { __data = _dataDict }

      public static var __parentType: Apollo.ParentType { Gql.Objects.Mutation }
      public static var __selections: [Apollo.Selection] { [
        .field("updateMessage", Bool.self, arguments: ["input": .variable("input")]),
      ] }

      /// Update the contents of a Message
      public var updateMessage: Bool { __data["updateMessage"] }
    }
  }

}