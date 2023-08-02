// @generated
// This file was automatically generated and should not be edited.

import Apollo

public extension Gql {
  /// A User's Role in this Chat silo
  enum AppUserRole: String, EnumType {
    /// A User with Admin priveleges
    case admin = "Admin"
    /// A standard User, can Chat, create Groups and update own Profile
    case member = "Member"
    /// A moderator, can manage flags, and content
    case moderator = "Moderator"
    /// A fully priveleged User
    case owner = "Owner"
  }

}