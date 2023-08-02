// @generated
// This file was automatically generated and should not be edited.

import Apollo

public extension Gql {
  /// A User's Role across all network silos, ie, InAppChat
  enum UserRole: String, EnumType {
    /// A User with InAppChat Admin priveleges
    case admin = "Admin"
    /// A standard User, usually a customer
    case member = "Member"
    /// A moderator, can manage flags, and content, support requests
    case moderator = "Moderator"
    /// A fully priveleged User
    case owner = "Owner"
  }

}