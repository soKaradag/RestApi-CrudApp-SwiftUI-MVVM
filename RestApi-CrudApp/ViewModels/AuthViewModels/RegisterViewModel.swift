//
//  RegisterViewModel.swift
//  RestApi-CrudApp
//
//  Created by Serdar Onur KARADAĞ on 17.08.2023.
//

import Foundation

class RegisterViewModel: ObservableObject {
    private var networkManager = NetworkManager.shared
    
    func register(username: String, password: String, completion: @escaping (Result<RegisterResponse, Error>) -> Void) {
        guard let url = URL(string: "\(networkManager.baseURL)/auth/register") else {
            return
        }
        
        let headers: [String:String] = [
            "Content-Type": "application/json",
            "api-key": "your-api-key"
        ]
        
        let body: [String: AnyHashable] = [
            "username": username,
            "password": password
        ]
        
        do {
            let httpBody = try JSONSerialization.data(withJSONObject: body)
            
            networkManager.performRequest(url: url, httpMethod: "POST", headers: headers, body: httpBody) { (result: Result<RegisterResponse, Error>) in
                switch result {
                case .success(_):
                    print("User Register successfuly.")
                case .failure(let error):
                    print("Register failed: \(error)")
                    // Handle logout failure here
                }
                completion(result)
            }
        } catch {
            print("Error creating HTTP body: \(error.localizedDescription)")
        }
        
    }
    
}
