// @generated
// This file was automatically generated and should not be edited.

import Apollo

public extension Gql {
  /// The type of a Chat entity.
  enum ChatType: String, EnumType {
    /// Represents an ephemeral Chat. A set of messages spawned around an Support Request or something of the like
    case conversation = "Conversation"
    /// A persistent Chat between two users.
    case directMessage = "DirectMessage"
    /// A persistent Chat created for a group of people. Can be branded with a name, description and image, as well as members with MemberRoles
    case group = "Group"
    /// Represents a conversation in reply to a particular message. Does not include nested threads.
    case thread = "Thread"
  }

}