// @generated
// This file was automatically generated and should not be edited.

import Apollo

public extension Gql {
  struct CreateGroupInput: InputObject {
    public private(set) var __data: InputDict

    public init(_ data: InputDict) {
      __data = data
    }

    public init(
      _private: GraphQLNullable<Bool> = nil,
      description: GraphQLNullable<String> = nil,
      image: GraphQLNullable<String> = nil,
      invites: GraphQLNullable<[ID?]> = nil,
      name: String
    ) {
      __data = InputDict([
        "_private": _private,
        "description": description,
        "image": image,
        "invites": invites,
        "name": name
      ])
    }

    /// The privacy status of the group to create
    public var _private: GraphQLNullable<Bool> {
      get { __data["_private"] }
      set { __data["_private"] = newValue }
    }

    /// The description of the group to create
    public var description: GraphQLNullable<String> {
      get { __data["description"] }
      set { __data["description"] = newValue }
    }

    /// The image of the group to create
    public var image: GraphQLNullable<String> {
      get { __data["image"] }
      set { __data["image"] = newValue }
    }

    /// A list of User IDs to invited ot the group
    public var invites: GraphQLNullable<[ID?]> {
      get { __data["invites"] }
      set { __data["invites"] = newValue }
    }

    /// The name of the group to create
    public var name: String {
      get { __data["name"] }
      set { __data["name"] = newValue }
    }
  }

}