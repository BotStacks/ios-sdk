//
// Token.swift
//
// Generated by openapi-generator
// https://openapi-generator.tech
//

import Foundation
#if canImport(AnyCodable)
import AnyCodable
#endif

public struct Token: Codable, JSONEncodable, Hashable {

    /** Access token to be provided in all API calls */
    public var accessToken: String
    /** Refresh token */
    public var refreshToken: String
    /** The interval in seconds over which token is valid */
    public var expiresIn: Double

    public init(accessToken: String, refreshToken: String, expiresIn: Double) {
        self.accessToken = accessToken
        self.refreshToken = refreshToken
        self.expiresIn = expiresIn
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case accessToken
        case refreshToken
        case expiresIn
    }

    // Encodable protocol methods

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(accessToken, forKey: .accessToken)
        try container.encode(refreshToken, forKey: .refreshToken)
        try container.encode(expiresIn, forKey: .expiresIn)
    }
}
