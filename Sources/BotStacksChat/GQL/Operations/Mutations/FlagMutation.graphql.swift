// @generated
// This file was automatically generated and should not be edited.

@_exported import Apollo

public extension Gql {
  class FlagMutation: GraphQLMutation {
    public static let operationName: String = "Flag"
    public static let operationDocument: Apollo.OperationDocument = .init(
      definition: .init(
        #"mutation Flag($input: CreateFlagInput!) { flag(input: $input) { __typename id } }"#
      ))

    public var input: CreateFlagInput

    public init(input: CreateFlagInput) {
      self.input = input
    }

    public var __variables: Variables? { ["input": input] }

    public struct Data: Gql.SelectionSet {
      public let __data: DataDict
      public init(_dataDict: DataDict) { __data = _dataDict }

      public static var __parentType: Apollo.ParentType { Gql.Objects.Mutation }
      public static var __selections: [Apollo.Selection] { [
        .field("flag", Flag.self, arguments: ["input": .variable("input")]),
      ] }

      /// Flag a User, Chat or Message
      public var flag: Flag { __data["flag"] }

      /// Flag
      ///
      /// Parent Type: `Flag`
      public struct Flag: Gql.SelectionSet {
        public let __data: DataDict
        public init(_dataDict: DataDict) { __data = _dataDict }

        public static var __parentType: Apollo.ParentType { Gql.Objects.Flag }
        public static var __selections: [Apollo.Selection] { [
          .field("__typename", String.self),
          .field("id", Gql.ID.self),
        ] }

        /// The ID of the Flag
        public var id: Gql.ID { __data["id"] }
      }
    }
  }

}