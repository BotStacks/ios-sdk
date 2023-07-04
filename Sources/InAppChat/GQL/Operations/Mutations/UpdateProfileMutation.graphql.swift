// @generated
// This file was automatically generated and should not be edited.

@_exported import Apollo

public extension Gql {
  class UpdateProfileMutation: GraphQLMutation {
    public static let operationName: String = "UpdateProfile"
    public static let document: Apollo.DocumentType = .notPersisted(
      definition: .init(
        #"""
        mutation UpdateProfile($input: UpdateProfileInput!) {
          updateProfile(input: $input)
        }
        """#
      ))

    public var input: UpdateProfileInput

    public init(input: UpdateProfileInput) {
      self.input = input
    }

    public var __variables: Variables? { ["input": input] }

    public struct Data: Gql.SelectionSet {
      public let __data: DataDict
      public init(_dataDict: DataDict) { __data = _dataDict }

      public static var __parentType: Apollo.ParentType { Gql.Objects.Mutation }
      public static var __selections: [Apollo.Selection] { [
        .field("updateProfile", Bool.self, arguments: ["input": .variable("input")]),
      ] }

      /// Updates the current User's profile
      public var updateProfile: Bool { __data["updateProfile"] }
    }
  }

}