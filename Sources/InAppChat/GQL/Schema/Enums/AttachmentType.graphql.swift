// @generated
// This file was automatically generated and should not be edited.

import Apollo

public extension Gql {
  /// The type of a Message attachment. Can be a File or some arbitrary data like Location or Vcard
  enum AttachmentType: String, EnumType {
    /// An audio file
    case audio = "audio"
    /// An arbitrary file
    case file = "file"
    /// An image
    case image = "image"
    /// A Location consisting of a combination of Latitude, Longitude and/or Address
    case location = "location"
    /// A VCard. According to Wikipedia: vCard, also known as VCF (Virtual Contact File), is a file format standard for electronic business cards.
    /// vCards can be attached to e-mail messages, sent via Multimedia Messaging Service (MMS), on the World Wide Web,
    /// instant messaging, NFC or through QR code. They can contain name and address information, phone numbers, e-mail addresses,
    /// URLs, logos, photographs, and audio clips.
    case vcard = "vcard"
    /// A video
    case video = "video"
  }

}