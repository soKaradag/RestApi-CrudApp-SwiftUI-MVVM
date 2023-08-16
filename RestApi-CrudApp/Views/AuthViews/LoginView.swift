//
//  LoginView.swift
//  RestApi-CrudApp
//
//  Created by Serdar Onur KARADAĞ on 17.08.2023.
//

import SwiftUI

struct LoginView: View {
    private let networkManager = NetworkManager.shared
    
    @EnvironmentObject var authVM: LoginViewModel
    
    @State private var username: String = ""
    @State private var password: String = ""
    
    var body: some View {
        VStack {
            TextField("Username", text: $username)
                .textFieldStyle(.roundedBorder)
            SecureField("Password", text: $password)
                .textFieldStyle(.roundedBorder)
            
            Button {
                authVM.login(username: username, password: password) { result in
                    switch result {
                    case .success(let response):
                        // Handle successful login
                        print("Login success: \(response)")
                        DispatchQueue.main.async {
                            authVM.isLoggedIn = true
                        }
                    case .failure(let error):
                        // Handle login failure
                        print("Login error: \(error)")
                        // You might want to show an error message to the user here
                    }
                }

            } label: {
                Text("LOGIN")

            }
            .padding(.top, 6)
            .buttonStyle(.bordered)
        }
    }
}

