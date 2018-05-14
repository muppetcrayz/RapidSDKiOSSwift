//
//  LogoutResponse.swift
//  MobileAPI
//
//  Created by Sage Conger on 5/14/18.
//  Copyright © 2018 DUBTEL. All rights reserved.
//

import Foundation

struct LogoutResponse: Codable {
    var status: String?
    var message: String?
    
    enum CodingKeys: String, CodingKey {
        case status = "status"
        case message = "message"
    }
}
