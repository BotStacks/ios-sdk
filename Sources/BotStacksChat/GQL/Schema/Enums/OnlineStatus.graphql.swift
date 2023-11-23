// @generated
// This file was automatically generated and should not be edited.

import Apollo

public extension Gql {
  /// A User's online status in this Chat silo
  enum OnlineStatus: String, EnumType {
    /// A user that is connected to the network but is "Away". This suggests a likely response in the near future
    case away = "Away"
    /// A user that has explicitely marked their Chat availbility as Do Not Disturb.
    /// The user is actively connected to the network and would like his peers to know he is connect4ed, but does not wish to receive any messages.
    case dnd = "DND"
    /// The user is not connected to the network. This suggests an entirely random response time
    case offline = "Offline"
    /// Actively available. The suggests a near immediate response
    case online = "Online"
  }

}