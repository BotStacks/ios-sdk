// @generated
// This file was automatically generated and should not be edited.

import Apollo

public extension Gql {
  struct ChatRegisterInput: InputObject {
    public private(set) var __data: InputDict

    public init(_ data: InputDict) {
      __data = data
    }

    public init(
      email: String,
      image: GraphQLNullable<String> = nil,
      password: String,
      username: String
    ) {
      __data = InputDict([
        "email": email,
        "image": image,
        "password": password,
        "username": username
      ])
    }

    public var email: String {
      get { __data["email"] }
      set { __data["email"] = newValue }
    }

    public var image: GraphQLNullable<String> {
      get { __data["image"] }
      set { __data["image"] = newValue }
    }

    public var password: String {
      get { __data["password"] }
      set { __data["password"] = newValue }
    }

    public var username: String {
      get { __data["username"] }
      set { __data["username"] = newValue }
    }
  }

}