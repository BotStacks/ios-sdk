//
//  Tenant.swift
//  InAppChat
//
//  Created by Zaid Daghestani on 1/27/23.
//

import Foundation
import SwiftyJSON

struct Tenant {
  let chatKey: String
  let chatURL: String
  let userKey: String
  let userURL: String
  let mqttURL: String
  let mqttPORT: String
  let mqttKey: String
  let baseUserId: String

}

var tenent: Tenant?
