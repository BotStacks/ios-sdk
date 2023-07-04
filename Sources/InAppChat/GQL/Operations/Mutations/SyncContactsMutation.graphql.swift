// @generated
// This file was automatically generated and should not be edited.

@_exported import Apollo

public extension Gql {
  class SyncContactsMutation: GraphQLMutation {
    public static let operationName: String = "SyncContacts"
    public static let document: Apollo.DocumentType = .notPersisted(
      definition: .init(
        #"""
        mutation SyncContacts($numbers: [String!]!) {
          syncContacts(numbers: $numbers)
        }
        """#
      ))

    public var numbers: [String]

    public init(numbers: [String]) {
      self.numbers = numbers
    }

    public var __variables: Variables? { ["numbers": numbers] }

    public struct Data: Gql.SelectionSet {
      public let __data: DataDict
      public init(_dataDict: DataDict) { __data = _dataDict }

      public static var __parentType: Apollo.ParentType { Gql.Objects.Mutation }
      public static var __selections: [Apollo.Selection] { [
        .field("syncContacts", Bool.self, arguments: ["numbers": .variable("numbers")]),
      ] }

      /// Sync a users phone book with the server
      public var syncContacts: Bool { __data["syncContacts"] }
    }
  }

}