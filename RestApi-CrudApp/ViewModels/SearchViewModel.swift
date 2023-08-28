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
    

    
    func searchPosts(searchTerm: String) {
        // Postları alma isteği için gerekli URL'yi oluşturun
        guard let url = URL(string: "\(networkManager.baseURL)/posts/search") else {
            print("Error: Invalid URL")
            return
        }

        
        // HTTP isteği için başlık ve diğer ayrıntıları ayarlayın
        let headers = [
            "api-key": networkManager.apiKey,
            "Authorization": "Bearer \(networkManager.jwtToken)",
            "Content-Type": "application/json"
        ]
        
        let body: [String: AnyHashable] = [
            "searchTerm": searchTerm
        ]
        
        do {
            // HTTP GET isteği gönderme
            let httpBody = try JSONSerialization.data(withJSONObject: body)
            
            networkManager.performRequest(url: url, httpMethod: "POST", headers: headers, body: httpBody) { (result: Result<[Post], Error>) in
                switch result {
                case .success(let receivedPosts):
                    // Başarılı yanıt aldık, postları güncelle
                    
                    DispatchQueue.main.async {
                        self.searchResults = receivedPosts
                    }
                    
                case .failure(let error):
                    // Hata durumunda işlem yapma
                    print("Post alma hatası: \(error)")
                }
            }
        } catch {
            print("Error creating HTTP body: \(error.localizedDescription)")
        }

    }
}

