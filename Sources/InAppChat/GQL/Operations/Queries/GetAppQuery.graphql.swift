// @generated
// This file was automatically generated and should not be edited.

@_exported import Apollo

public extension Gql {
  class GetAppQuery: GraphQLQuery {
    public static let operationName: String = "GetApp"
    public static let document: Apollo.DocumentType = .notPersisted(
      definition: .init(
        #"""
        query GetApp {
          app {
            __typename
            wek
          }
        }
        """#
      ))

    public init() {}

    public struct Data: Gql.SelectionSet {
      public let __data: DataDict
      public init(_dataDict: DataDict) { __data = _dataDict }

      public static var __parentType: Apollo.ParentType { Gql.Objects.Query }
      public static var __selections: [Apollo.Selection] { [
        .field("app", App.self),
      ] }

      public var app: App { __data["app"] }

      /// App
      ///
      /// Parent Type: `App`
      public struct App: Gql.SelectionSet {
        public let __data: DataDict
        public init(_dataDict: DataDict) { __data = _dataDict }

        public static var __parentType: Apollo.ParentType { Gql.Objects.App }
        public static var __selections: [Apollo.Selection] { [
          .field("__typename", String.self),
          .field("wek", String.self),
        ] }

        public var wek: String { __data["wek"] }
      }
    }
  }

}