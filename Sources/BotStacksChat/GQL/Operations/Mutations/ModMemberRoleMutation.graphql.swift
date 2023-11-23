// @generated
// This file was automatically generated and should not be edited.

@_exported import Apollo

public extension Gql {
  class ModMemberRoleMutation: GraphQLMutation {
    public static let operationName: String = "ModMemberRole"
    public static let operationDocument: Apollo.OperationDocument = .init(
      definition: .init(
        #"mutation ModMemberRole($input: ModMemberInput!) { modMember(input: $input) }"#
      ))

    public var input: ModMemberInput

    public init(input: ModMemberInput) {
      self.input = input
    }

    public var __variables: Variables? { ["input": input] }

    public struct Data: Gql.SelectionSet {
      public let __data: DataDict
      public init(_dataDict: DataDict) { __data = _dataDict }

      public static var __parentType: Apollo.ParentType { Gql.Objects.Mutation }
      public static var __selections: [Apollo.Selection] { [
        .field("modMember", Bool.self, arguments: ["input": .variable("input")]),
      ] }

      /// Mod a user Role in a Chat
      public var modMember: Bool { __data["modMember"] }
    }
  }

}