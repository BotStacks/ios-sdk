//
// ReportCategory.swift
//
// Generated by openapi-generator
// https://openapi-generator.tech
//

import Foundation
#if canImport(AnyCodable)
import AnyCodable
#endif

public enum ReportCategory: String, Codable, CaseIterable {
    case abuse = "abuse"
    case spam = "spam"
    case other = "other"
    case inappropriate = "inappropriate"
}