// @generated
// This file was automatically generated and should not be edited.

@_exported import Apollo

public extension Gql {
  class ReadMessagesMutation: GraphQLMutation {
    public static let operationName: String = "ReadMessages"
    public static let document: Apollo.DocumentType = .notPersisted(
      definition: .init(
        #"""
        mutation ReadMessages($header: String!) {
          read(header: $header)
        }
        """#
      ))

    public var header: String

    public init(header: String) {
      self.header = header
    }

    public var __variables: Variables? { ["header": header] }

    public struct Data: Gql.SelectionSet {
      public let __data: DataDict
      public init(_dataDict: DataDict) { __data = _dataDict }

      public static var __parentType: Apollo.ParentType { Gql.Objects.Mutation }
      public static var __selections: [Apollo.Selection] { [
        .field("read", Bool.self, arguments: ["header": .variable("header")]),
      ] }

      /// Consume all Messages for the current Device up to a given Message header
      public var read: Bool { __data["read"] }
    }
  }

}