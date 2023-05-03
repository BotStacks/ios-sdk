//
// GroupUpdatEventChangeDataGroupType.swift
//
// Generated by openapi-generator
// https://openapi-generator.tech
//

import Foundation
#if canImport(AnyCodable)
import AnyCodable
#endif

/** Applicable for created/nameChanged/profilePicChanged/descriptionChanged eventTypes */
public struct GroupUpdatEventChangeDataGroupType: Codable, JSONEncodable, Hashable {

    public enum Previous: String, Codable, CaseIterable {
        case _public = "public"
        case _private = "private"
    }
    public enum New: String, Codable, CaseIterable {
        case _public = "public"
        case _private = "private"
    }
    /** Previous value. Applicable only for nameChanged */
    public var previous: Previous?
    /** new value */
    public var new: New

    public init(previous: Previous? = nil, new: New) {
        self.previous = previous
        self.new = new
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case previous
        case new
    }

    // Encodable protocol methods

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(previous, forKey: .previous)
        try container.encode(new, forKey: .new)
    }
}
