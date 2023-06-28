// @generated
// This file was automatically generated and should not be edited.

import Apollo

public extension Gql {
  /// An input variant of Attachment for sending messages
  struct AttachmentInput: InputObject {
    public private(set) var __data: InputDict

    public init(_ data: InputDict) {
      __data = data
    }

    public init(
      address: GraphQLNullable<String> = nil,
      data: GraphQLNullable<String> = nil,
      duration: GraphQLNullable<Int> = nil,
      height: GraphQLNullable<Int> = nil,
      latitude: GraphQLNullable<Latitude> = nil,
      longitude: GraphQLNullable<Longitude> = nil,
      mime: GraphQLNullable<String> = nil,
      type: GraphQLEnum<AttachmentType>,
      url: String,
      width: GraphQLNullable<Int> = nil
    ) {
      __data = InputDict([
        "address": address,
        "data": data,
        "duration": duration,
        "height": height,
        "latitude": latitude,
        "longitude": longitude,
        "mime": mime,
        "type": type,
        "url": url,
        "width": width
      ])
    }

    /// The address of the location
    public var address: GraphQLNullable<String> {
      get { __data["address"] }
      set { __data["address"] = newValue }
    }

    /// The raw data of the Attachment if it is a VCard
    public var data: GraphQLNullable<String> {
      get { __data["data"] }
      set { __data["data"] = newValue }
    }

    /// The duration of the audio or video in seconds
    public var duration: GraphQLNullable<Int> {
      get { __data["duration"] }
      set { __data["duration"] = newValue }
    }

    /// The height of the image or video in integer pixels
    public var height: GraphQLNullable<Int> {
      get { __data["height"] }
      set { __data["height"] = newValue }
    }

    /// The latitude of the location
    public var latitude: GraphQLNullable<Latitude> {
      get { __data["latitude"] }
      set { __data["latitude"] = newValue }
    }

    /// The longitude of the location
    public var longitude: GraphQLNullable<Longitude> {
      get { __data["longitude"] }
      set { __data["longitude"] = newValue }
    }

    /// The mime type of the attachment if it is a file, image, video or audio object
    public var mime: GraphQLNullable<String> {
      get { __data["mime"] }
      set { __data["mime"] = newValue }
    }

    /// The type of the Attachment
    public var type: GraphQLEnum<AttachmentType> {
      get { __data["type"] }
      set { __data["type"] = newValue }
    }

    /// The url of the file or 'data' if an arbitrary object
    public var url: String {
      get { __data["url"] }
      set { __data["url"] = newValue }
    }

    /// The width of the image or video in integer pixels
    public var width: GraphQLNullable<Int> {
      get { __data["width"] }
      set { __data["width"] = newValue }
    }
  }

}