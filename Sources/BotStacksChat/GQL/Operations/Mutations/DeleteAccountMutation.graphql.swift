// @generated
// This file was automatically generated and should not be edited.

@_exported import Apollo

public extension Gql {
  class DeleteAccountMutation: GraphQLMutation {
    public static let operationName: String = "DeleteAccount"
    public static let operationDocument: Apollo.OperationDocument = .init(
      definition: .init(
        #"mutation DeleteAccount { deleteAccount }"#
      ))

    public init() {}

    public struct Data: Gql.SelectionSet {
      public let __data: DataDict
      public init(_dataDict: DataDict) { __data = _dataDict }

      public static var __parentType: Apollo.ParentType { Gql.Objects.Mutation }
      public static var __selections: [Apollo.Selection] { [
        .field("deleteAccount", Bool.self),
      ] }

      public var deleteAccount: Bool { __data["deleteAccount"] }
    }
  }

}