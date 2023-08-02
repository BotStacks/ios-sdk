// @generated
// This file was automatically generated and should not be edited.

@_exported import Apollo

public extension Gql {
  struct FDelete: Gql.SelectionSet, Fragment {
    public static var fragmentDefinition: StaticString {
      "fragment FDelete on DeleteEvent { __typename id kind }"
    }

    public let __data: DataDict
    public init(_dataDict: DataDict) { __data = _dataDict }

    public static var __parentType: Apollo.ParentType { Gql.Objects.DeleteEvent }
    public static var __selections: [Apollo.Selection] { [
      .field("__typename", String.self),
      .field("id", Gql.ID.self),
      .field("kind", GraphQLEnum<Gql.DeleteEntity>.self),
    ] }

    public var id: Gql.ID { __data["id"] }
    public var kind: GraphQLEnum<Gql.DeleteEntity> { __data["kind"] }
  }

}