//
//  LoginViewModel.swift
//  RestApi-CrudApp
//
//  Created by Serdar Onur KARADAĞ on 17.08.2023.
//


import Foundation
import SwiftUI

class LoginViewModel: ObservableObject {
    private let networkManager = NetworkManager.shared
    
    @AppStorage("IS_USER_IN") var isLoggedIn: Bool = false
    
    func setJwtToken(_ token: String) {
        networkManager.jwtToken = token
    }
    
    func setIsUserLoggedIn(_ isLoggedIn: Bool) {
        networkManager.isUserLoggedIn = isLoggedIn
    }

    func setCurrentUserId(_ userId: Int) {
        networkManager.currentId = userId
    }
    
    func setCurrentUsername(_ username: String) {
        networkManager.currentUsername = username
    }
    
    func login(username: String, password: String, completion: @escaping (Result<LoginResponse, Error>) -> Void) {
        guard let loginURL = URL(string: "\(networkManager.baseURL)/auth/login") else {
            return
        }
        
        let headers: [String: String] = [
            "Content-Type": "application/json",
            "api-key": "your-api-key"
        ]
        
        let body: [String: AnyHashable] = [
            "username": username,
            "password": password
        ]
        
        do {
            let httpBody = try JSONSerialization.data(withJSONObject: body)
            
            networkManager.performRequest(url: loginURL, httpMethod: "POST", headers: headers, body: httpBody) { (result: Result<LoginResponse, Error>) in
                switch result {
                case .success(let response):
                    DispatchQueue.main.async {
                        // Handle successful login here
                        self.handleSuccessfulLogin(response: response)
                    }
                case .failure(let error):
                    print("Login failed: \(error)")
                    // Handle login failure here
                }
                completion(result)
            }
        } catch {
            print("Error creating HTTP body: \(error.localizedDescription)")
        }
    }
    
    func handleSuccessfulLogin(response: LoginResponse) {
        // Handle successful login here
        print("Login successful. Token: \(response.token)")
        setJwtToken(response.token)
        do {
            let payload = try self.decodeJwt(jwtToken: response.token)
            if let userId = payload["id"] as? Int {
                setCurrentUserId(userId) // Set the user ID in NetworkManager
            } else {
                print("Error extracting user ID from JWT payload.")
            }
            if let username = payload["username"] as? String {
                setCurrentUsername(username) // Set the username in NetworkManager
            } else {
                print("Error extracting username from JWT payload.")
            }
            setIsUserLoggedIn(true)
        } catch {
            print("Error decoding JWT payload: \(error)")
        }
    }
    
    func logout(completion: @escaping (Result<LogoutResponse, Error>) -> Void) {
        let logoutURL = URL(string: "\(networkManager.baseURL)/auth/logout")!
        
        let headers: [String: String] = [
            "Content-Type": "application/json",
            "api-key": networkManager.apiKey,
            "Authorization": "Bearer \(networkManager.jwtToken)"
        ]
        
        networkManager.performRequest(url: logoutURL, httpMethod: "POST", headers: headers, body: nil) { (result: Result<LogoutResponse, Error>) in
            switch result {
            case .success(_):
                DispatchQueue.main.async {
                    // Handle successful logout here
                    self.handleSuccessfulLogout()
                }
            case .failure(let error):
                print("Logout failed: \(error)")
                // Handle logout failure here
            }
            completion(result)
        }
    }
    
    func handleSuccessfulLogout() {
        // Handle successful logout here
        networkManager.jwtToken = ""
        networkManager.currentId = 0
        networkManager.currentUsername = ""
        isLoggedIn = false
    }
    
    func decodeJwt(jwtToken jwt: String) throws -> [String: Any] {
        enum DecodeErrors: Error {
            case badToken
            case other
        }

        func base64Decode(_ base64: String) throws -> Data {
            let base64 = base64
                .replacingOccurrences(of: "-", with: "+")
                .replacingOccurrences(of: "_", with: "/")
            let padded = base64.padding(toLength: ((base64.count + 3) / 4) * 4, withPad: "=", startingAt: 0)
            guard let decoded = Data(base64Encoded: padded) else {
                throw DecodeErrors.badToken
            }
            return decoded
        }

        func decodeJWTPart(_ value: String) throws -> [String: Any] {
            let bodyData = try base64Decode(value)
            let json = try JSONSerialization.jsonObject(with: bodyData, options: [])
            guard let payload = json as? [String: Any] else {
                throw DecodeErrors.other
            }
            return payload
        }

        let segments = jwt.components(separatedBy: ".")
        guard segments.count >= 2 else {
            throw DecodeErrors.badToken
        }

        return try decodeJWTPart(segments[1])
    }
    
    func returnPayload() -> [String: Any]? {
        // Your JWT token string
        let jwtToken = networkManager.jwtToken
        
        // Check if JWT token is empty (user is not logged in)
        guard !jwtToken.isEmpty else {
            print("User is not logged in. JWT token is empty.")
            return nil
        }

        do {
            // Call the decodeJwt function
            let payload = try decodeJwt(jwtToken: jwtToken)
            return payload
        } catch {
            // Handle the error
            print("Error decoding JWT: \(error)")
            return nil
        }
    }

    func getUsernameFromToken() -> String? {
        guard let payload = returnPayload() else {
            return nil
        }
        
        if let username = payload["username"] as? String {
            return username
        } else {
            return nil
        }
    }
    
    func getUserIdFromToken() -> Int? {
        guard let payload = returnPayload() else {
            return nil
        }
        
        if let userId = payload["id"] as? Int {
            return userId
        } else {
            return nil
        }
    }
}
