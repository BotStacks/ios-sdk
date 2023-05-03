//
// SearchInput.swift
//
// Generated by openapi-generator
// https://openapi-generator.tech
//

import Foundation
#if canImport(AnyCodable)
import AnyCodable
#endif

public struct SearchInput: Codable, JSONEncodable, Hashable {

    public enum ResultCategories: String, Codable, CaseIterable {
        case messages = "messages"
        case files = "files"
        case channels = "channels"
    }
    public var searchQuery: SearchQuery
    /** Result category list */
    public var resultCategories: [ResultCategories]?

    public init(searchQuery: SearchQuery, resultCategories: [ResultCategories]? = nil) {
        self.searchQuery = searchQuery
        self.resultCategories = resultCategories
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case searchQuery
        case resultCategories
    }

    // Encodable protocol methods

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(searchQuery, forKey: .searchQuery)
        try container.encodeIfPresent(resultCategories, forKey: .resultCategories)
    }
}
