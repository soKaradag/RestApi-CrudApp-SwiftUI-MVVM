//
//  PostModel.swift
//  RestApi-CrudApp
//
//  Created by Serdar Onur KARADAĞ on 17.08.2023.
//

import Foundation

class Post: Codable, Identifiable {
    var id: Int?
    var userid: Int
    var username: String
    var title: String
    var content: String
    var createdAt: Date?

    init(id: Int? = nil, userid: Int, username: String, title: String, content: String, createdAt: Date?) {
        self.id = id
        self.userid = userid
        self.username = username
        self.title = title
        self.content = content
        self.createdAt = createdAt
    }
    
}
