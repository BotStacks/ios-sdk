//
//  String+URLEncoded.swift
//  InAppChat
//
//  Created by Zaid Daghestani on 2/8/23.
//

import Foundation

private let urlAllowed: CharacterSet =
    .alphanumerics.union(.init(charactersIn: "-._~")) // as per RFC 3986

public extension String {
    var urlEncoded: String {
        return addingPercentEncoding(withAllowedCharacters: urlAllowed) ?? ""
    }
  
  var url: URL? {
    return URL(string: self)
  }
}
