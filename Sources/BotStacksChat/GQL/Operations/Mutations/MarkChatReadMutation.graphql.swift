// @generated
// This file was automatically generated and should not be edited.

@_exported import Apollo

public extension Gql {
  class MarkChatReadMutation: GraphQLMutation {
    public static let operationName: String = "markChatRead"
    public static let operationDocument: Apollo.OperationDocument = .init(
      definition: .init(
        #"mutation markChatRead($id: ID!) { markChatRead(chat: $id) }"#
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
        .field("markChatRead", Bool.self, arguments: ["chat": .variable("id")]),
      ] }

      /// Marks a Chat as read now for the current User
      public var markChatRead: Bool { __data["markChatRead"] }
    }
  }

}