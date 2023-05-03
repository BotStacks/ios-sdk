//
// GroupUpdateEvent.swift
//
// Generated by openapi-generator
// https://openapi-generator.tech
//

import Foundation
#if canImport(AnyCodable)
import AnyCodable
#endif

public struct GroupUpdateEvent: Codable, JSONEncodable, Hashable {

    public var eventTriggeredByUser: APIUser
    /** Group ID with which event is related */
    public var groupId: String
    /** Thread ID of associated group */
    public var threadId: String
    public var eventList: [GroupUpdateEventItem]

    public init(eventTriggeredByUser: APIUser, groupId: String, threadId: String, eventList: [GroupUpdateEventItem]) {
        self.eventTriggeredByUser = eventTriggeredByUser
        self.groupId = groupId
        self.threadId = threadId
        self.eventList = eventList
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case eventTriggeredByUser
        case groupId
        case threadId
        case eventList
    }

    // Encodable protocol methods

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(eventTriggeredByUser, forKey: .eventTriggeredByUser)
        try container.encode(groupId, forKey: .groupId)
        try container.encode(threadId, forKey: .threadId)
        try container.encode(eventList, forKey: .eventList)
    }
}
