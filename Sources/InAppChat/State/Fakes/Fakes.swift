//
//  Fkaes.swift
//  InAppChatUI
//
//  Created by Zaid Daghestani on 1/26/23.
//

import Fakery
import Foundation
import SwiftDate

let faker = Faker(locale: "en-US")

func randomImage() -> String {
  return randomImage(300)
}

func randomImage(_ size: Int) -> String {
  return "https://picsum.photos/seed/\(faker.number.randomInt())/\(size)"
}

func randomImage(_ width: Int, _ height: Int) -> String {
  return "https://picsum.photos/seed/\(faker.number.randomInt())/\(width)/\(height)"
}

func chance(_ num: Int, outOf: Int) -> Bool {
  return faker.number.randomInt(min: 1, max: outOf) <= num
}

func random<T>(count: Int, item: () -> T) -> [T] {
  let num = faker.number.randomInt(min: 0, max: count)
  if num > 0 {
    return (0..<num).map({ _ in item() })
  }
  return []
}

func randomAmount<T>(from: [T]) -> [T] {
  if from.isEmpty {return []}
  var count = faker.number.randomInt(min: 0, max: from.count)
  var els = from
  if count > 0 {
    var ret: [T] = []
    while count > 0 {
      let i = faker.number.randomInt(min: 0, max: els.count)
      count -= 1
      ret.append(els[i])
      els.remove(at: i)
    }
    return ret
  } else {
    return []
  }
}
