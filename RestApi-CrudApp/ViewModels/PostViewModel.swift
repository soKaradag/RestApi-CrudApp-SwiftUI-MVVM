//
//  PostViewModel.swift
//  RestApi-CrudApp
//
//  Created by Serdar Onur KARADAĞ on 17.08.2023.
//

import Foundation

class PostViewModel: ObservableObject {
    @Published var posts: [Post] = []
    @Published var userPosts: [Post] = []

    
    private let networkManager = NetworkManager.shared

    
    func fetchPosts() {
        guard let url = URL(string: "\(networkManager.baseURL)/posts") else {
            print("Error: Invalid URL")
            return
        }
        
        let headers = [
            "api-key": networkManager.apiKey,
            "Authorization": "Bearer \(networkManager.jwtToken)",
            "Content-Type": "application/json"
        ]

        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601

        networkManager.performRequest(url: url, httpMethod: "GET", headers: headers, body: nil) { (result: Result<[Post], Error>) in
            switch result {
            case .success(let fetchedPosts):
                DispatchQueue.main.async {
                    self.posts = fetchedPosts
                }
                
            case .failure(let error):
                print("Error fetching posts: \(error)")
            }
        }
    }
    
    func fetchUserPost(profileId: Int) {
        guard let url = URL(string: "\(networkManager.baseURL)/posts/\(profileId)/posts") else {
            print("Error: Invalid URL")
            return
        }
    
        let headers = [
            "api-key": networkManager.apiKey,
            "Authorization": "Bearer \(networkManager.jwtToken)",
            "Content-Type": "application/json"
        ]
        
        networkManager.performRequest(url: url, httpMethod: "GET", headers: headers, body: nil) { (result: Result<[Post], Error>) in
            switch result {
            case .success(let fetchedPosts):
                DispatchQueue.main.async {
                    self.userPosts = fetchedPosts
                }
            case.failure(let error):
                print("Cant fetched user post \(error)")
                return
            }
        }
    }
    
    func deletePost(postId: Int) {
        guard let url = URL(string: "\(networkManager.baseURL)/posts/\(postId)") else {
            print("Error: Invalid URL")
            return
        }
    
        let headers = [
            "api-key": networkManager.apiKey,
            "Authorization": "Bearer \(networkManager.jwtToken)",
            "Content-Type": "application/json"
        ]
        
        let body: [String: AnyHashable] = [
            "postId": postId
        ]
        
        do {
            let httpBody = try JSONSerialization.data(withJSONObject: body)
            networkManager.performRequest(url: url, httpMethod: "DELETE", headers: headers, body: httpBody) { (result: Result<DeleteResponse, Error>)  in
                switch result {
                case .success(let response):
                    print("Post deletion successful.\(response)")
                    
                case .failure(let error):
                    print("Post deletion failed: \(error)")
                }
            }
        } catch  {
            print("Post deletion failed: \(error)")
        }
        
    }
    
    func addPost(title: String, content: String, completion: @escaping (Result<AddPostResponse, Error>) -> Void) {
        guard let url = URL(string: "\(networkManager.baseURL)/posts/addPost") else {
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
            "title": title,
            "content": content
        ]
        
        do {
            let httpBody = try JSONSerialization.data(withJSONObject: body)
            
            networkManager.performRequest(url: url, httpMethod: "POST", headers: headers, body: httpBody) { (result: Result<AddPostResponse, Error>) in
                switch result {
                case .success(let response):
                    print("Post add successful.\(response)")
                    
                case .failure(let error):
                    print("Post add failed: \(error)")
                }
            }
        } catch {
            print("Post add failed: \(error)")
        }
    }
}
