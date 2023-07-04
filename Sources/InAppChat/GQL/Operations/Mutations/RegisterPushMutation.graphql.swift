// @generated
// This file was automatically generated and should not be edited.

@_exported import Apollo

public extension Gql {
  class RegisterPushMutation: GraphQLMutation {
    public static let operationName: String = "registerPush"
    public static let document: Apollo.DocumentType = .notPersisted(
      definition: .init(
        #"""
        mutation registerPush($token: String!, $kind: DeviceType!, $fcm: Boolean) {
          registerPush(token: $token, kind: $kind, fcm: $fcm)
        }
        """#
      ))

    public var token: String
    public var kind: GraphQLEnum<DeviceType>
    public var fcm: GraphQLNullable<Bool>

    public init(
      token: String,
      kind: GraphQLEnum<DeviceType>,
      fcm: GraphQLNullable<Bool>
    ) {
      self.token = token
      self.kind = kind
      self.fcm = fcm
    }

    public var __variables: Variables? { [
      "token": token,
      "kind": kind,
      "fcm": fcm
    ] }

    public struct Data: Gql.SelectionSet {
      public let __data: DataDict
      public init(_dataDict: DataDict) { __data = _dataDict }

      public static var __parentType: Apollo.ParentType { Gql.Objects.Mutation }
      public static var __selections: [Apollo.Selection] { [
        .field("registerPush", Bool?.self, arguments: [
          "token": .variable("token"),
          "kind": .variable("kind"),
          "fcm": .variable("fcm")
        ]),
      ] }

      /// Registers a push token for a device
      public var registerPush: Bool? { __data["registerPush"] }
    }
  }

}