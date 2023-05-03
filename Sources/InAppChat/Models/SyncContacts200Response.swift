//
// SyncContacts200Response.swift
//
// Generated by openapi-generator
// https://openapi-generator.tech
//

import Foundation
#if canImport(AnyCodable)
import AnyCodable
#endif

public struct SyncContacts200Response: Codable, JSONEncodable, Hashable {

    public var result: APIUser?

    public init(result: APIUser? = nil) {
        self.result = result
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case result
    }

    // Encodable protocol methods

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(result, forKey: .result)
    }
}
