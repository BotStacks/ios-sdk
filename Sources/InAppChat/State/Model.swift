//
//  Model.swift
//  InAppChat
//
//  Created by Zaid Daghestani on 1/27/23.
//

import Foundation
import SwiftyJSON

protocol Model: Identifiable {
  var id: String { get }

  init(_ json: JSON)

  func update(_ json: JSON)

  static var cache: [String: Self] { get set }
  static var id: String { get }

}

extension Model {

  public static func get(_ id: String) -> Self? {
    return cache[id]
  }

  static func get(_ json: JSON) -> Self {
    if let item = get(json["id"].stringValue) {
      item.update(json)
      return item
    } else {
      let item = Self.init(json)
      cache[item.id] = item
      return item
    }
  }

}

extension JSON {
  func model<T: Model>() -> T? {
    return dictionary.map({ T.get(JSON($0)) })
  }

  func model<T: Model>() -> [T]? {
    return array?.map({ T.get(JSON($0)) })
  }

  func modelValue<T: Model>() -> T {
    return T.get(JSON(dictionaryValue))
  }

  func modelValue<T: Model>() -> [T] {
    return arrayValue.map({ T.get(JSON($0)) })
  }

  func jsoni<T: JSONInitializable>() -> T? {
    return dictionary.map({ T.init(JSON($0)) })
  }

  func jsoniValue<T: JSONInitializable>() -> T {
    return T.init(JSON(dictionaryValue))
  }
}

protocol JSONInitializable {
  init(_ json: JSON)
}

protocol JSONSerializable {
  func toJSON() -> [String: Any]
}

protocol JSONable: JSONInitializable, JSONSerializable {}
