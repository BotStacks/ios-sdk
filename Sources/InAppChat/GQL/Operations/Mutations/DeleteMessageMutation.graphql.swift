// @generated
// This file was automatically generated and should not be edited.

@_exported import Apollo

public extension Gql {
  class DeleteMessageMutation: GraphQLMutation {
    public static let operationName: String = "DeleteMessage"
    public static let document: Apollo.DocumentType = .notPersisted(
      definition: .init(
        #"""
        mutation DeleteMessage($id: ID!) {
          removeMessage(id: $id)
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
        .field("removeMessage", Bool.self, arguments: ["id": .variable("id")]),
      ] }

      /// Delete a Message if priveledged
      public var removeMessage: Bool { __data["removeMessage"] }
    }
  }

}