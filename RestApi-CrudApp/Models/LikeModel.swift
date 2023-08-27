//
//  LikeModel.swift
//  RestApi-CrudApp
//
//  Created by Serdar Onur KARADAĞ on 27.08.2023.
//

import Foundation


class Like: Codable, Identifiable {
    var id: Int?
    var userid: Int?
    var username: String?
    var createdAt: Date?
    
    enum CodingKeys: String, CodingKey {
        case id = "like_id"
        case userid = "like_userid"
        case username = "like_username"
        case createdAt = "like_createdAt"
    }
    
    init(id: Int? = nil, userid: Int? = nil, username: String? = nil, createdAt: Date? = nil) {
        self.id = id
        self.userid = userid
        self.username = username
        self.createdAt = createdAt
    }
}
