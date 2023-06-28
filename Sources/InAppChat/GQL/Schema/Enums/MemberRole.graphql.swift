// @generated
// This file was automatically generated and should not be edited.

import Apollo

public extension Gql {
  /// The role of a User Member of a Chat
  enum MemberRole: String, EnumType {
    /// An Admin, has near total permissional control over a Chat
    case admin = "Admin"
    /// An Invite sent to a User for a Chat. The User can join the Chat if invited, even if the Chat is private
    case invited = "Invited"
    /// A User that was kicked from a group Chat. Retained in order to prevent the User rejoining the Chat.
    case kicked = "Kicked"
    /// A member can send Messages and read Messages from a Chat
    case member = "Member"
    /// An Owner, has total permisisonal control over a Chat
    case owner = "Owner"
    /// A User that rejected an Invite to a Chat. Retained in order to prevent multiple Invites
    case rejectedInvite = "RejectedInvite"
  }

}