//
//  Upload.swift
//  InAppChat
//
//  Created by Zaid Daghestani on 6/28/23.
//

import Foundation

public struct MultipartRequest {
  
  public let boundary: String
  
  private let separator: String = "\r\n"
  private var data: Data
  
  public init(boundary: String = UUID().uuidString) {
    self.boundary = boundary
    self.data = .init()
  }
  
  private mutating func append(_ string: String) {
    data.append(string.data(using: .utf8)!)
  }
  
  private mutating func appendBoundarySeparator() {
    append("--\(boundary)\(separator)")
  }
  
  private mutating func appendSeparator() {
    append(separator)
  }
  
  private func disposition(_ key: String) -> String {
    "Content-Disposition: form-data; name=\"\(key)\""
  }
  
  public mutating func add(
    key: String,
    value: String
  ) {
    appendBoundarySeparator()
    append(disposition(key) + separator)
    appendSeparator()
    append(value + separator)
  }
  
  public mutating func add(
    key: String,
    fileName: String,
    fileMimeType: String,
    fileData: Data
  ) {
    appendBoundarySeparator()
    append(disposition(key) + "; filename=\"\(fileName)\"" + separator)
    append("Content-Type: \(fileMimeType)" + separator + separator)
    data.append(fileData)
    appendSeparator()
  }
  
  public var httpContentTypeHeadeValue: String {
    "multipart/form-data; boundary=\(boundary)"
  }
  
  public var httpBody: Data {
    var bodyData = data
    bodyData.append("--\(boundary)--".data(using: .utf8)!)
    return bodyData
  }
}
