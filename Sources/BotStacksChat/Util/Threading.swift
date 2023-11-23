//
//  Threading.swift
//  BotStacksChat
//
//  Created by Zaid Daghestani on 2/6/23.
//

import Foundation


public func publish(_ cl: @escaping () -> Void) {
  DispatchQueue.main.async(execute: cl)
}
