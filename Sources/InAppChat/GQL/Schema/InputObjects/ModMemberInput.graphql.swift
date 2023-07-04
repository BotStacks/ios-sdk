// @generated
// This file was automatically generated and should not be edited.

import Apollo

public extension Gql {
  struct ModMemberInput: InputObject {
    public private(set) var __data: InputDict

    public init(_ data: InputDict) {
      __data = data
    }

    public init(
      chat: ID,
      role: GraphQLNullable<GraphQLEnum<MemberRole>> = nil,
      user: ID
    ) {
      __data = InputDict([
        "chat": chat,
        "role": role,
        "user": user
      ])
    }

    /// The Chat to modify
    public var chat: ID {
      get { __data["chat"] }
      set { __data["chat"] = newValue }
    }

    /// The new Role of the User
    public var role: GraphQLNullable<GraphQLEnum<MemberRole>> {
      get { __data["role"] }
      set { __data["role"] = newValue }
    }

    /// The User to modify
    public var user: ID {
      get { __data["user"] }
      set { __data["user"] = newValue }
    }
  }

}