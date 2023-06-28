//
//  File.swift
//  InAppChat
//
//  Created by Zaid Daghestani on 6/28/23.
//

import Foundation


struct File {
  let url: URL
  let mimeType: String
  let name: String
  
  init(url: URL) {
    self.url = url
    self.name = url.lastPathComponent
    self.mimeType = url.mimeType()
  }
}

extension URL {
  public func mimeType() -> String {
    if let mimeType = UTType(filenameExtension: self.pathExtension)?.preferredMIMEType {
      return mimeType
    }
    else {
      return "application/octet-stream"
    }
  }
}
