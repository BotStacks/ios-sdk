// @generated
// This file was automatically generated and should not be edited.

import Apollo

public extension Gql {
  /// Represents the fields updatable on a group Chat
  struct UpdateGroupInput: InputObject {
    public private(set) var __data: InputDict

    public init(_ data: InputDict) {
      __data = data
    }

    public init(
      _private: GraphQLNullable<Bool> = nil,
      description: GraphQLNullable<String> = nil,
      id: ID,
      image: GraphQLNullable<String> = nil,
      name: GraphQLNullable<String> = nil
    ) {
      __data = InputDict([
        "_private": _private,
        "description": description,
        "id": id,
        "image": image,
        "name": name
      ])
    }

    /// The new privacy of the group
    public var _private: GraphQLNullable<Bool> {
      get { __data["_private"] }
      set { __data["_private"] = newValue }
    }

    /// The new description of the group
    public var description: GraphQLNullable<String> {
      get { __data["description"] }
      set { __data["description"] = newValue }
    }

    /// The ID of the chat to update
    public var id: ID {
      get { __data["id"] }
      set { __data["id"] = newValue }
    }

    /// The new image of the group
    public var image: GraphQLNullable<String> {
      get { __data["image"] }
      set { __data["image"] = newValue }
    }

    /// The new name of the group
    public var name: GraphQLNullable<String> {
      get { __data["name"] }
      set { __data["name"] = newValue }
    }
  }

}