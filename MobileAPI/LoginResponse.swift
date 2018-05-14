//
//  LoginResponse.swift
//  MobileAPI
//
//  Created by Sage Conger on 5/14/18.
//  Copyright © 2018 DUBTEL. All rights reserved.
//

import Foundation

struct LoginResponse: Codable {
    var session_id: String?
    var user_id: String?
    var status: String?
    
    enum CodingKeys: String, CodingKey {
        case session_id = "session_id"
        case user_id = "user_id"
        case status = "status"
    }
}
