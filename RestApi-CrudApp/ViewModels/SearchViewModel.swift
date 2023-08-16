//
//  SearchViewModel.swift
//  RestApi-CrudApp
//
//  Created by Serdar Onur KARADAĞ on 17.08.2023.
//

import Foundation

class SearchViewModel: ObservableObject {
    private let networkManager = NetworkManager.shared
    
    @Published var searchResults: [Post] = []
    
    func searchPosts(searchTerm: String, completion: @escaping (Result<[Post], Error>) -> Void) {
        guard let url = URL(string: "\(networkManager.baseURL)/posts/search") else {
            print("Error: Invalid URL")
            return
        }

        
        let headers = [
            "api-key": networkManager.apiKey,
            "Authorization": "Bearer \(networkManager.jwtToken)",
            "Content-Type": "application/json"
        ]
        
        let body: [String: AnyHashable] = [
            "searchTerm": searchTerm
        ]
        
        do {
            let httpBody = try JSONSerialization.data(withJSONObject: body)
            
            networkManager.performRequest(url: url, httpMethod: "POST", headers: headers, body: httpBody) { (result: Result<[Post], Error>) in
                switch result {
                case .success(let posts):
                    DispatchQueue.main.async {
                        self.searchResults = posts
                    }
                case .failure(let error):
                    print("Search failed: \(error)")
                }
                completion(result)
            }
        } catch {
            print("Error creating HTTP body: \(error.localizedDescription)")
        }
    }
}
