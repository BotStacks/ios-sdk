//
// SelfUpdateItem.swift
//
// Generated by openapi-generator
// https://openapi-generator.tech
//

import Foundation
#if canImport(AnyCodable)
import AnyCodable
#endif

public struct SelfUpdateItem: Codable, JSONEncodable, Hashable {

    public enum EventType: String, Codable, CaseIterable {
        case availabilitystatuschanged = "availabilityStatusChanged"
        case notificationsettingchangedglobal = "notificationSettingChangedGlobal"
        case notificationsettingschangedthread = "notificationSettingsChangedThread"
        case userblockedstatuschanged = "userBlockedStatusChanged"
    }
    /** Type of the event. */
    public var eventType: EventType
    public var eventData: UserSelfUpdateEventData

    public init(eventType: EventType, eventData: UserSelfUpdateEventData) {
        self.eventType = eventType
        self.eventData = eventData
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case eventType
        case eventData
    }

    // Encodable protocol methods

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(eventType, forKey: .eventType)
        try container.encode(eventData, forKey: .eventData)
    }
}
