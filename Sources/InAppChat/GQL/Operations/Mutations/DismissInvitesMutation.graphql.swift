// @generated
// This file was automatically generated and should not be edited.

@_exported import Apollo

public extension Gql {
  class DismissInvitesMutation: GraphQLMutation {
    public static let operationName: String = "DismissInvites"
    public static let document: Apollo.DocumentType = .notPersisted(
      definition: .init(
        #"""
        mutation DismissInvites($chat: ID!) {
          dismissInvites(chat: $chat)
        }
        """#
      ))

    public var chat: ID

    public init(chat: ID) {
      self.chat = chat
    }

    public var __variables: Variables? { ["chat": chat] }

    public struct Data: Gql.SelectionSet {
      public let __data: DataDict
      public init(_dataDict: DataDict) { __data = _dataDict }

      public static var __parentType: Apollo.ParentType { Gql.Objects.Mutation }
      public static var __selections: [Apollo.Selection] { [
        .field("dismissInvites", Bool?.self, arguments: ["chat": .variable("chat")]),
      ] }

      /// Rejects a Chat invite for the current User
      public var dismissInvites: Bool? { __data["dismissInvites"] }
    }
  }

}