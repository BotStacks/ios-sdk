// @generated
// This file was automatically generated and should not be edited.

@_exported import Apollo

public extension Gql {
  class RejectInviteMutation: GraphQLMutation {
    public static let operationName: String = "RejectInvite"
    public static let document: Apollo.DocumentType = .notPersisted(
      definition: .init(
        #"""
        mutation RejectInvite($id: ID!) {
          rejectInvite(chat: $id)
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
        .field("rejectInvite", Bool?.self, arguments: ["chat": .variable("id")]),
      ] }

      /// Rejects a Chat invite for the current User
      public var rejectInvite: Bool? { __data["rejectInvite"] }
    }
  }

}