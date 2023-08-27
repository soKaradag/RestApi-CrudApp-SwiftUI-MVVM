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
    
    func fetchPosts() async {
        // Postları alma isteği için gerekli URL'yi oluşturun
        guard let url = URL(string: "\(networkManager.baseURL)/posts") else {
            print("Error: Invalid URL")
            return
        }
        
        // HTTP isteği için başlık ve diğer ayrıntıları ayarlayın
        let headers = [
            "api-key": networkManager.apiKey,
            "Authorization": "Bearer \(networkManager.jwtToken)",
            "Content-Type": "application/json"
        ]
        
        // HTTP GET isteği gönderme
        networkManager.performRequest(url: url, httpMethod: "GET", headers: headers, body: nil) { (result: Result<[Post], Error>) in
            switch result {
            case .success(let receivedPosts):
                // Başarılı yanıt aldık, postları güncelle
                
                DispatchQueue.main.async {
                    self.posts = receivedPosts
                    print(receivedPosts[0].likes?.count ?? 0)
                }
                
                
            case .failure(let error):
                // Hata durumunda işlem yapma
                print("Post alma hatası: \(error)")
            }
        }
    }
    
    
    func fetchUserPost(profileId: Int) {
        // Postları alma isteği için gerekli URL'yi oluşturun
        guard let url = URL(string: "\(networkManager.baseURL)/posts/\(profileId)/posts") else {
            print("Error: Invalid URL")
            return
        }

        
        // HTTP isteği için başlık ve diğer ayrıntıları ayarlayın
        let headers = [
            "api-key": networkManager.apiKey,
            "Authorization": "Bearer \(networkManager.jwtToken)",
            "Content-Type": "application/json"
        ]
        
        // HTTP GET isteği gönderme
        networkManager.performRequest(url: url, httpMethod: "GET", headers: headers, body: nil) { (result: Result<[Post], Error>) in
            switch result {
            case .success(let receivedPosts):
                // Başarılı yanıt aldık, postları güncelle
                
                DispatchQueue.main.async {
                    self.userPosts = receivedPosts
                    print(receivedPosts[0].likes?.count ?? 0)
                }
                
                
            case .failure(let error):
                // Hata durumunda işlem yapma
                print("Post alma hatası: \(error)")
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
