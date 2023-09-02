//
//  CommentViewModel.swift
//  RestApi-CrudApp
//
//  Created by Serdar Onur KARADAĞ on 31.08.2023.
//

import Foundation

class CommentViewModel: ObservableObject {
    private let networkManager = NetworkManager.shared
    
    func addComment(postid: Int, content: String)  {
        guard let url = URL(string: "\(networkManager.baseURL)/comments/addComment") else {
            print("Error: Invalid URL")
            return
        }
        
        let headers = [
            "api-key": networkManager.apiKey,
            "Authorization": "Bearer \(networkManager.jwtToken)",
            "Content-Type": "application/json"
        ]
        
        let body: [String: AnyHashable] = [
            "userId": networkManager.currentId,
            "username": networkManager.currentUsername,
            "postid": postid,
            "content": content
        ]
        
        do {
            let httpBody = try JSONSerialization.data(withJSONObject: body)
            
            networkManager.performRequest(url: url, httpMethod: "POST", headers: headers, body: httpBody) { (result: Result<AddCommentResponse, Error>) in
                switch result {
                case.success(let response):
                    print("Comment add successful, \(response)")
                    print(content)
                case.failure(let error):
                    print("Comment add failed, \(error)")
                }
            }
        } catch {
            print("Comment add failed. \(error)")
        }
        
    }
    
    func deleteComment(commentId: Int) async {
        guard let url = URL(string: "\(networkManager.baseURL)/comments/deleteComment") else {
            print("Error: Invalid URL")
            return
        }
        
        let headers = [
            "api-key": networkManager.apiKey,
            "Authorization": "Bearer \(networkManager.jwtToken)",
            "Content-Type": "application/json"
        ]
        
        let body: [String: AnyHashable] = [
            "userId": networkManager.currentId,
            "username": networkManager.currentUsername,
            "commentId": commentId
        ]
        
        do {
            let httpBody = try JSONSerialization.data(withJSONObject: body)
            
            networkManager.performRequest(url: url, httpMethod: "POST", headers: headers, body: httpBody) { (result: Result<DeleteCommentResponse, Error>) in
                switch result {
                case.success(let response):
                    print("Comment delete successful, \(response)")
                    print("\(commentId)")
                case.failure(let error):
                    print("Comment delete failed, \(error)")
                }
            }
        } catch {
            print("Comment delete failed. \(error)")
        }
        
    }
    
}
