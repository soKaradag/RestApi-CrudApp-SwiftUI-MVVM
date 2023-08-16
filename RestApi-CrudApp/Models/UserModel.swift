//
//  UserModel.swift
//  RestApi-CrudApp
//
//  Created by Serdar Onur KARADAĞ on 17.08.2023.
//

import Foundation

class User: Codable, Identifiable {
    var id: Int?
    var username: String
    var password: String?
    
    init(id: Int? = nil, username: String, password: String? = nil) {
        self.id = id
        self.username = username
        self.password = password
    }
    
}
