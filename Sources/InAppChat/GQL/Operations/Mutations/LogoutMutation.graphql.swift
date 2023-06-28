// @generated
// This file was automatically generated and should not be edited.

@_exported import Apollo

public extension Gql {
  class LogoutMutation: GraphQLMutation {
    public static let operationName: String = "Logout"
    public static let document: Apollo.DocumentType = .notPersisted(
      definition: .init(
        #"""
        mutation Logout {
          logout
        }
        """#
      ))

    public init() {}

    public struct Data: Gql.SelectionSet {
      public let __data: DataDict
      public init(_dataDict: DataDict) { __data = _dataDict }

      public static var __parentType: Apollo.ParentType { Gql.Objects.Mutation }
      public static var __selections: [Apollo.Selection] { [
        .field("logout", Bool?.self),
      ] }

      /// Logs out of a device, deleting it, and wiping out the auth token
      public var logout: Bool? { __data["logout"] }
    }
  }

}