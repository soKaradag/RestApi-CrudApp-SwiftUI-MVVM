//
//  Response.swift
//  RestApi-CrudApp
//
//  Created by Serdar Onur KARADAĞ on 17.08.2023.
//

import Foundation

struct RegisterResponse: Codable {
    let message: String
}

struct LoginResponse: Codable {
    let token: String
}

struct LogoutResponse: Codable {
    let message: String
}

struct DeleteResponse: Codable {
    let message: String
}

struct AddPostResponse: Codable {
    let message: String
}
