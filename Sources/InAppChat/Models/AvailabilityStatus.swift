//
// AvailabilityStatus.swift
//
// Generated by openapi-generator
// https://openapi-generator.tech
//

import Foundation
#if canImport(AnyCodable)
import AnyCodable
#endif

/** availability status of user. i.e. online/away/invisible/dnd */
public enum AvailabilityStatus: String, Codable, CaseIterable {
    case online = "online"
    case away = "away"
    case invisible = "invisible"
    case dnd = "dnd"
    case offline = "offline"
}