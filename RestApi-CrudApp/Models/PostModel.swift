//
//  PostModel.swift
//  RestApi-CrudApp
//
//  Created by Serdar Onur KARADAĞ on 17.08.2023.
//

import Foundation

class Post: Codable, Identifiable {
    var id: Int
    var userid: Int
    var username: String
    var title: String
    var content: String
    var createdAt: Date?
    var likes: [Like]?

    enum CodingKeys: String, CodingKey {
        case id = "post_id"
        case userid = "post_userid"
        case username = "post_username"
        case title = "post_title"
        case content = "post_content"
        case createdAt = "post_createdAt"
        case likes
    }

    init(id: Int, userid: Int, username: String, title: String, content: String, createdAt: Date? = nil, likes: [Like]? = nil) {
        self.id = id
        self.userid = userid
        self.username = username
        self.title = title
        self.content = content
        self.createdAt = createdAt
        self.likes = likes
    }
}
