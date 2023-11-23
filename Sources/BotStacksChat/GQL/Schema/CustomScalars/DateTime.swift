// @generated
// This file was automatically generated and can be edited to
// implement advanced custom scalar functionality.
//
// Any changes to this file will not be overwritten by future
// code generation execution.

import Apollo
import SwiftDate

public extension Gql {
  /// A date-time string at UTC, such as 2007-12-03T10:15:30Z, is compliant with the date-time format outlined in section 5.6 of the RFC 3339 profile of the ISO 8601 standard for representation of dates and times using the Gregorian calendar.
  ///
  /// This scalar is a description of an exact instant on the timeline such as the instant that a user account was created.
  ///
  /// This scalar ignores leap seconds (thereby assuming that a minute constitutes 59 seconds). In this respect, it diverges from the RFC 3339 profile.
  ///
  /// Where an RFC 3339 compliant date-time string has a time-zone other than UTC, it is shifted to UTC. For example, the date-time string 2016-01-01T14:10:20+01:00 is shifted to 2016-01-01T13:10:20Z.
  typealias DateTime = Date

}

extension Date: CustomScalarType {
  public init(_jsonValue value: JSONValue) throws {
    guard let str = value as? String,
          let date = str.toDate()?.date
      else {
      throw JSONDecodingError.couldNotConvert(value: value, to: Date.self)
    }
    
    self = date
  }
  
  public var _jsonValue: JSONValue {
    self.toISO()
  }
}
