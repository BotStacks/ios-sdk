// @generated
// This file was automatically generated and should not be edited.

@_exported import Apollo

public extension Gql {
  class UpdateGroupMutation: GraphQLMutation {
    public static let operationName: String = "UpdateGroup"
    public static let operationDocument: Apollo.OperationDocument = .init(
      definition: .init(
        #"mutation UpdateGroup($input: UpdateGroupInput!) { updateGroup(input: $input) }"#
      ))

    public var input: UpdateGroupInput

    public init(input: UpdateGroupInput) {
      self.input = input
    }

    public var __variables: Variables? { ["input": input] }

    public struct Data: Gql.SelectionSet {
      public let __data: DataDict
      public init(_dataDict: DataDict) { __data = _dataDict }

      public static var __parentType: Apollo.ParentType { Gql.Objects.Mutation }
      public static var __selections: [Apollo.Selection] { [
        .field("updateGroup", Bool.self, arguments: ["input": .variable("input")]),
      ] }

      /// Update a group Chat
      public var updateGroup: Bool { __data["updateGroup"] }
    }
  }

}