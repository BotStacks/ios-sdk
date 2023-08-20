// @generated
// This file was automatically generated and should not be edited.

import Apollo

public extension Gql {
  /// The input necessary to send a Message to a Chat
  struct SendMessageInput: InputObject {
    public private(set) var __data: InputDict

    public init(_ data: InputDict) {
      __data = data
    }

    public init(
      attachments: GraphQLNullable<[AttachmentInput]> = nil,
      chat: ID,
      id: ID,
      parent: GraphQLNullable<ID> = nil,
      text: GraphQLNullable<String> = nil
    ) {
      __data = InputDict([
        "attachments": attachments,
        "chat": chat,
        "id": id,
        "parent": parent,
        "text": text
      ])
    }

    /// Input Attachments to include with the Message
    public var attachments: GraphQLNullable<[AttachmentInput]> {
      get { __data["attachments"] }
      set { __data["attachments"] = newValue }
    }

    /// The Chat to send the Message to
    public var chat: ID {
      get { __data["chat"] }
      set { __data["chat"] = newValue }
    }

    /// The client generated ID for the message
    public var id: ID {
      get { __data["id"] }
      set { __data["id"] = newValue }
    }

    /// The ID of the Message this Message is replying to if it is a reply
    public var parent: GraphQLNullable<ID> {
      get { __data["parent"] }
      set { __data["parent"] = newValue }
    }

    /// The text content of the message. May contain markdown and @mentions
    public var text: GraphQLNullable<String> {
      get { __data["text"] }
      set { __data["text"] = newValue }
    }
  }

}