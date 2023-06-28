// @generated
// This file was automatically generated and should not be edited.

import Apollo

public extension Gql {
  /// Login input fields
  struct LoginInput: InputObject {
    public private(set) var __data: InputDict

    public init(_ data: InputDict) {
      __data = data
    }

    public init(
      access_token: GraphQLNullable<String> = nil,
      device: GraphQLNullable<CreateDeviceInput> = nil,
      display_name: GraphQLNullable<String> = nil,
      email: GraphQLNullable<String> = nil,
      image: GraphQLNullable<String> = nil,
      user_id: ID,
      username: GraphQLNullable<String> = nil
    ) {
      __data = InputDict([
        "access_token": access_token,
        "device": device,
        "display_name": display_name,
        "email": email,
        "image": image,
        "user_id": user_id,
        "username": username
      ])
    }

    /// The access token for the user on the silo owner's app network.
    /// This will be used to verify the login authenticity with the silo owner's backend
    public var access_token: GraphQLNullable<String> {
      get { __data["access_token"] }
      set { __data["access_token"] = newValue }
    }

    /// The Device that is logging in
    public var device: GraphQLNullable<CreateDeviceInput> {
      get { __data["device"] }
      set { __data["device"] = newValue }
    }

    /// The display name of the User
    public var display_name: GraphQLNullable<String> {
      get { __data["display_name"] }
      set { __data["display_name"] = newValue }
    }

    /// The email of the user
    public var email: GraphQLNullable<String> {
      get { __data["email"] }
      set { __data["email"] = newValue }
    }

    /// The image associated with the User
    public var image: GraphQLNullable<String> {
      get { __data["image"] }
      set { __data["image"] = newValue }
    }

    /// The ID of the user on the silo owner's app network
    public var user_id: ID {
      get { __data["user_id"] }
      set { __data["user_id"] = newValue }
    }

    /// The username of the User
    public var username: GraphQLNullable<String> {
      get { __data["username"] }
      set { __data["username"] = newValue }
    }
  }

}