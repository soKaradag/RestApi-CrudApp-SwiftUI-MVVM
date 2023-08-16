//
//  UserViewModel.swift
//  RestApi-CrudApp
//
//  Created by Serdar Onur KARADAĞ on 17.08.2023.
//

import Foundation

class UserViewModel: ObservableObject {
    @Published var users: [User] = []
    
    
    private let networkManager = NetworkManager.shared
    private let loginVM = LoginViewModel()
    
    
    func fetchUsers() {
        guard let url = URL(string: "\(networkManager.baseURL)/users") else {
            print("Error: Invalid URL")
            return
        }
        
        let headers = [
            "api-key": networkManager.apiKey,
            "Authorization": "Bearer \(networkManager.jwtToken)",
            "Content-Type": "application/json"
        ]
        
        networkManager.performRequest(url: url, httpMethod: "GET", headers: headers, body: nil) { (result: Result<[User], Error>) in
            switch result {
            case .success(let fetchedUsers):
                DispatchQueue.main.async {
                    self.users = fetchedUsers
                }
            case .failure(let error):
                print("Error fetching users: \(error)")
            }
        }
    }
    
    func deleteUser() {
        guard let url = URL(string: "\(networkManager.baseURL)/users/deleteUser") else {
            print("Error: Invalid URL")
            return
        }
        
        let headers = [
            "api-key": networkManager.apiKey,
            "Authorization": "Bearer \(networkManager.jwtToken)"
        ]
        
        networkManager.performRequest(url: url, httpMethod: "DELETE", headers: headers, body: nil) { (result: Result<DeleteResponse, Error>) in
            switch result {
            case .success(let response):
                print("User deletion successful.\(response)")
                
            case .failure(let error):
                print("User deletion failed: \(error)")
            }
        }
        
    }
    
    func handleSuccessfulDelete() {
        loginVM.handleSuccessfulLogout()
    }
}

