// @generated
// This file was automatically generated and should not be edited.

import Apollo

public extension Gql {
  /// The input with params necessary to create a Device
  struct CreateDeviceInput: InputObject {
    public private(set) var __data: InputDict

    public init(_ data: InputDict) {
      __data = data
    }

    public init(
      device_type: GraphQLEnum<DeviceType>,
      fcm_token: GraphQLNullable<String> = nil,
      ik: String,
      opk: [String],
      pks: String,
      spk: String
    ) {
      __data = InputDict([
        "device_type": device_type,
        "fcm_token": fcm_token,
        "ik": ik,
        "opk": opk,
        "pks": pks,
        "spk": spk
      ])
    }

    /// The type of the device
    public var device_type: GraphQLEnum<DeviceType> {
      get { __data["device_type"] }
      set { __data["device_type"] = newValue }
    }

    /// The fcm token of the device if available
    public var fcm_token: GraphQLNullable<String> {
      get { __data["fcm_token"] }
      set { __data["fcm_token"] = newValue }
    }

    /// The Persistent Identity Key of the Device
    public var ik: String {
      get { __data["ik"] }
      set { __data["ik"] = newValue }
    }

    /// The Device's One Time PreKey Set
    public var opk: [String] {
      get { __data["opk"] }
      set { __data["opk"] = newValue }
    }

    /// The Device's PreKey Signature Sig(IK, Encode(SPK))
    public var pks: String {
      get { __data["pks"] }
      set { __data["pks"] = newValue }
    }

    /// The Device's Signed PreKey
    public var spk: String {
      get { __data["spk"] }
      set { __data["spk"] = newValue }
    }
  }

}