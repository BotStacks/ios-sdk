// @generated
// This file was automatically generated and should not be edited.

@_exported import Apollo

public extension Gql {
  class GetNFTConfigQuery: GraphQLQuery {
    public static let operationName: String = "GetNFTConfig"
    public static let operationDocument: Apollo.OperationDocument = .init(
      definition: .init(
        #"query GetNFTConfig { app { __typename nft { __typename enabled nft_name contract_address image_url } } }"#
      ))

    public init() {}

    public struct Data: Gql.SelectionSet {
      public let __data: DataDict
      public init(_dataDict: DataDict) { __data = _dataDict }

      public static var __parentType: Apollo.ParentType { Gql.Objects.Query }
      public static var __selections: [Apollo.Selection] { [
        .field("app", App.self),
      ] }

      public var app: App { __data["app"] }

      /// App
      ///
      /// Parent Type: `App`
      public struct App: Gql.SelectionSet {
        public let __data: DataDict
        public init(_dataDict: DataDict) { __data = _dataDict }

        public static var __parentType: Apollo.ParentType { Gql.Objects.App }
        public static var __selections: [Apollo.Selection] { [
          .field("__typename", String.self),
          .field("nft", Nft?.self),
        ] }

        /// An optional NFT configuration for the app
        public var nft: Nft? { __data["nft"] }

        /// App.Nft
        ///
        /// Parent Type: `NFTConfig`
        public struct Nft: Gql.SelectionSet {
          public let __data: DataDict
          public init(_dataDict: DataDict) { __data = _dataDict }

          public static var __parentType: Apollo.ParentType { Gql.Objects.NFTConfig }
          public static var __selections: [Apollo.Selection] { [
            .field("__typename", String.self),
            .field("enabled", Bool.self),
            .field("nft_name", String.self),
            .field("contract_address", String.self),
            .field("image_url", String.self),
          ] }

          /// If NFT login is enabled for the app
          public var enabled: Bool { __data["enabled"] }
          /// The name of the NFT
          public var nft_name: String { __data["nft_name"] }
          /// The contract address of the NFT
          public var contract_address: String { __data["contract_address"] }
          /// The image URL for a token
          public var image_url: String { __data["image_url"] }
        }
      }
    }
  }

}