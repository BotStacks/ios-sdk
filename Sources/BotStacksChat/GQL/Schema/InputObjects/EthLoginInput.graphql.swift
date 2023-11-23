// @generated
// This file was automatically generated and should not be edited.

import Apollo

public extension Gql {
  /// NFt login input fields
  struct EthLoginInput: InputObject {
    public private(set) var __data: InputDict

    public init(_ data: InputDict) {
      __data = data
    }

    public init(
      device: GraphQLNullable<CreateDeviceInput> = nil,
      image: GraphQLNullable<String> = nil,
      signed_message: String,
      token_id: String,
      username: String,
      wallet: String
    ) {
      __data = InputDict([
        "device": device,
        "image": image,
        "signed_message": signed_message,
        "token_id": token_id,
        "username": username,
        "wallet": wallet
      ])
    }

    /// The Device that is logging in
    public var device: GraphQLNullable<CreateDeviceInput> {
      get { __data["device"] }
      set { __data["device"] = newValue }
    }

    /// The image to associate with this user
    public var image: GraphQLNullable<String> {
      get { __data["image"] }
      set { __data["image"] = newValue }
    }

    /// A signed message stating that the user intends to sign with the selected NFT owned by this wallet
    public var signed_message: String {
      get { __data["signed_message"] }
      set { __data["signed_message"] = newValue }
    }

    /// The ID of the token the user is logging in with
    public var token_id: String {
      get { __data["token_id"] }
      set { __data["token_id"] = newValue }
    }

    /// The username to assign to this user
    public var username: String {
      get { __data["username"] }
      set { __data["username"] = newValue }
    }

    /// The wallet address
    public var wallet: String {
      get { __data["wallet"] }
      set { __data["wallet"] = newValue }
    }
  }

}