// @generated
// This file was automatically generated and can be edited to
// implement advanced custom scalar functionality.
//
// Any changes to this file will not be overwritten by future
// code generation execution.

import Apollo

public extension Gql {
  /// A field whose value is a valid decimal degrees latitude number(opens in a new tab) (53.471).
  ///
  /// The input value can be either in decimal (53.471) or sexagesimal (53° 21' 16") format.
  ///
  /// The output value is always in decimal format (53.471).
  ///
  /// The maximum decimal degrees' precision is 8. See Decimal Degrees Precision(opens in a new tab) for more information.
  typealias Latitude = Double

}

extension Double: CustomScalarType {
  public init (_jsonValue value: JSONValue) throws {
    guard let val = value as? Double else {
      throw JSONDecodingError.couldNotConvert(value: value, to: Foundation.UUID.self)
    }
    
    self = val
  }
  
  public var _jsonValue: JSONValue {
    self
  }
}
