// @generated
// This file was automatically generated and should not be edited.

import Apollo

public extension Gql {
  /// The fields necessary to create a Flag
  struct CreateFlagInput: InputObject {
    public private(set) var __data: InputDict

    public init(_ data: InputDict) {
      __data = data
    }

    public init(
      chat: GraphQLNullable<ID> = nil,
      message: GraphQLNullable<ID> = nil,
      reason: String,
      user: GraphQLNullable<ID> = nil
    ) {
      __data = InputDict([
        "chat": chat,
        "message": message,
        "reason": reason,
        "user": user
      ])
    }

    /// The Chat ID for the Chat subject of the Flag
    public var chat: GraphQLNullable<ID> {
      get { __data["chat"] }
      set { __data["chat"] = newValue }
    }

    /// The Message ID for the Message subject of the Flag
    public var message: GraphQLNullable<ID> {
      get { __data["message"] }
      set { __data["message"] = newValue }
    }

    /// The reason for the flag
    public var reason: String {
      get { __data["reason"] }
      set { __data["reason"] = newValue }
    }

    /// The User ID for the User subject of the Flag
    public var user: GraphQLNullable<ID> {
      get { __data["user"] }
      set { __data["user"] = newValue }
    }
  }

}