// @generated
// This file was automatically generated and should not be edited.

@_exported import Apollo

public extension Gql {
  struct FDevice: Gql.SelectionSet, Fragment {
    public static var fragmentDefinition: StaticString {
      "fragment FDevice on Device { __typename id created_at updated_at ik spk pks opk }"
    }

    public let __data: DataDict
    public init(_dataDict: DataDict) { __data = _dataDict }

    public static var __parentType: Apollo.ParentType { Gql.Objects.Device }
    public static var __selections: [Apollo.Selection] { [
      .field("__typename", String.self),
      .field("id", Gql.ID.self),
      .field("created_at", Gql.DateTime.self),
      .field("updated_at", Gql.DateTime.self),
      .field("ik", String.self),
      .field("spk", String.self),
      .field("pks", String.self),
      .field("opk", [String].self),
    ] }

    /// The Device's ID as provided by the Device
    public var id: Gql.ID { __data["id"] }
    /// The date this Device was created
    public var created_at: Gql.DateTime { __data["created_at"] }
    /// The date this Device was updated
    public var updated_at: Gql.DateTime { __data["updated_at"] }
    /// The Device's Identity Key
    public var ik: String { __data["ik"] }
    /// The Device's Signed PreKey
    public var spk: String { __data["spk"] }
    /// The Device's PreKey Signature Sig(IK, Encode(SPK))
    public var pks: String { __data["pks"] }
    /// The Device's One Time PreKey Set
    public var opk: [String] { __data["opk"] }
  }

}