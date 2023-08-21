// @generated
// This file was automatically generated and should not be edited.

import Apollo

public protocol Gql_SelectionSet: Apollo.SelectionSet & Apollo.RootSelectionSet
where Schema == Gql.SchemaMetadata {}

public protocol Gql_InlineFragment: Apollo.SelectionSet & Apollo.InlineFragment
where Schema == Gql.SchemaMetadata {}

public protocol Gql_MutableSelectionSet: Apollo.MutableRootSelectionSet
where Schema == Gql.SchemaMetadata {}

public protocol Gql_MutableInlineFragment: Apollo.MutableSelectionSet & Apollo.InlineFragment
where Schema == Gql.SchemaMetadata {}

public extension Gql {
  typealias ID = String

  typealias SelectionSet = Gql_SelectionSet

  typealias InlineFragment = Gql_InlineFragment

  typealias MutableSelectionSet = Gql_MutableSelectionSet

  typealias MutableInlineFragment = Gql_MutableInlineFragment

  enum SchemaMetadata: Apollo.SchemaMetadata {
    public static let configuration: Apollo.SchemaConfiguration.Type = SchemaConfiguration.self

    public static func objectType(forTypename typename: String) -> Object? {
      switch typename {
      case "Query": return Gql.Objects.Query
      case "App": return Gql.Objects.App
      case "NFTConfig": return Gql.Objects.NFTConfig
      case "Mutation": return Gql.Objects.Mutation
      case "Auth": return Gql.Objects.Auth
      case "User": return Gql.Objects.User
      case "Device": return Gql.Objects.Device
      case "Member": return Gql.Objects.Member
      case "Chat": return Gql.Objects.Chat
      case "Message": return Gql.Objects.Message
      case "Attachment": return Gql.Objects.Attachment
      case "Mention": return Gql.Objects.Mention
      case "Invite": return Gql.Objects.Invite
      case "Subscription": return Gql.Objects.Subscription
      case "InviteEvent": return Gql.Objects.InviteEvent
      case "ReactionEvent": return Gql.Objects.ReactionEvent
      case "ReplyEvent": return Gql.Objects.ReplyEvent
      case "DeleteEvent": return Gql.Objects.DeleteEvent
      case "EntityEvent": return Gql.Objects.EntityEvent
      default: return nil
      }
    }
  }

  enum Objects {}
  enum Interfaces {}
  enum Unions {}

}