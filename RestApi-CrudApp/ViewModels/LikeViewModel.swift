//
//  LikeViewModel.swift
//  RestApi-CrudApp
//
//  Created by Serdar Onur KARADAĞ on 27.08.2023.
//

import Foundation

class LikeViewModel: ObservableObject {
    private let networkManager = NetworkManager.shared
    
    @Published var isLiked: Bool = false
    
    let postVM = PostViewModel()
    
    func checkIfLiked(post: Post) {
        // Postun likes özelliği boşsa veya kullanıcı kimliği nullsa, false olarak ayarla.
        guard let likes = post.likes else {
            isLiked = false
            return
        }
        
        // Likes içinde dolaş ve kullanıcı kimliğini kontrol et.
        if likes.contains(where: { $0.userid == networkManager.currentId }) {
            isLiked = true
        } else {
            isLiked = false
        }
    }

    
    func addLike(postid: Int) async  {
        guard let url = URL(string: "\(networkManager.baseURL)/likes/addLike") else {
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
            "postid": postid
        ]
        
        do {
            let httpBody = try JSONSerialization.data(withJSONObject: body)
            
            networkManager.performRequest(url: url, httpMethod: "POST", headers: headers, body: httpBody) { (result: Result<AddLikeResponse, Error>) in
                switch result {
                case .success(let response):
                    print("Like add successful.\(response)")
                    
                    DispatchQueue.main.async {
                        self.isLiked = true
                    }
                    
                    
                    
                case .failure(let error):
                    print("Like add failed: \(error)")
                }
            }
        } catch {
            print("Like add failed: \(error)")
        }
    }
    
    func deleteLike(postid: Int) async  {
        guard let url = URL(string: "\(networkManager.baseURL)/likes/deleteLike") else {
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
            "postid": postid
        ]
        
        do {
            let httpBody = try JSONSerialization.data(withJSONObject: body)
            
            networkManager.performRequest(url: url, httpMethod: "DELETE", headers: headers, body: httpBody) { (result: Result<DeleteLikeResponse, Error>) in
                switch result {
                case .success(let response):
                    print("Like delete successful.\(response)")
                    
                    DispatchQueue.main.async {
                        self.isLiked = false
                    }
                    


                case .failure(let error):
                    print("Like delete failed: \(error)")
                }
            }
        } catch {
            print("Like delete failed: \(error)")
        }
    }
}
