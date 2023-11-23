// @generated
// This file was automatically generated and should not be edited.

@_exported import Apollo

public extension Gql {
  class LeaveChatMutation: GraphQLMutation {
    public static let operationName: String = "LeaveChat"
    public static let operationDocument: Apollo.OperationDocument = .init(
      definition: .init(
        #"mutation LeaveChat($id: ID!) { leave(chat: $id) }"#
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
        .field("leave", Bool.self, arguments: ["chat": .variable("id")]),
      ] }

      /// Leaves a Chat
      public var leave: Bool { __data["leave"] }
    }
  }

}