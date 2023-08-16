//
//  NetworkManager.swift
//  RestApi-CrudApp
//
//  Created by Serdar Onur KARADAĞ on 17.08.2023.
//

import Foundation
import SwiftUI


class NetworkManager {
    static let shared = NetworkManager()
    private let session: URLSession
    
    let baseURL = "http://localhost:3000"
    let apiKey = "your-api-key"
    
    @AppStorage("CURRENT_JWT") var jwtToken = ""
    @AppStorage("CURRENT_ID") var currentId: Int = 0
    @AppStorage("CURRENT_USERNAME") var currentUsername: String = ""
    @AppStorage("IS_USER_LOGGED_IN") var isUserLoggedIn: Bool = false
    
    private init() {
         let config = URLSessionConfiguration.default
         session = URLSession(configuration: config)
     }
    
    func performRequest<T: Codable>(url: URL, httpMethod: String, headers: [String: String], body: Data?, completion: @escaping (Result<T, Error>) -> Void) {
        var request = URLRequest(url: url)
        request.httpMethod = httpMethod
        request.allHTTPHeaderFields = headers
        request.httpBody = body

        let task = session.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let data = data else {
                completion(.failure(NetworkError.noData))
                return
            }

            do {
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .custom { decoder in
                    let container = try decoder.singleValueContainer()
                    let dateString = try container.decode(String.self)
                    
                    // Customize this date formatter to match your API's date format
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
                    
                    if let date = dateFormatter.date(from: dateString) {
                        return date
                    } else {
                        throw DecodingError.dataCorruptedError(in: container, debugDescription: "Expected date string to be in your custom format")
                    }
                }
                
                let decodedData = try decoder.decode(T.self, from: data)
                completion(.success(decodedData))
            } catch {
                completion(.failure(error))
            }
        }
        task.resume()
    }
}

enum NetworkError: Error {
    case noData
}
