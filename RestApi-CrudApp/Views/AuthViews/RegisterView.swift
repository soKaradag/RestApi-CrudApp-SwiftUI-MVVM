//
//  RegisterView.swift
//  RestApi-CrudApp
//
//  Created by Serdar Onur KARADAĞ on 17.08.2023.
//

import SwiftUI

struct RegisterView: View {
    private let networkManager = NetworkManager.shared
    
    @EnvironmentObject var registerVM: RegisterViewModel
    
    @State private var username: String = ""
    @State private var password: String = ""
    @State private var passwordConfirm: String = ""
    
    @Binding var isSuccess: Bool
    
    var passwordsMatch: Bool {
        return password == passwordConfirm
    }
    
    var body: some View {
        VStack {
            TextField("Username", text: $username)
                .textFieldStyle(.roundedBorder)
            SecureField("Password", text: $password)
                .textFieldStyle(.roundedBorder)
            SecureField("Confirm Password", text: $passwordConfirm)
                .textFieldStyle(.roundedBorder)
            
            Button {
                
                registerVM.register(username: username, password: password) { result in
                    switch result {
                    case .success(let response):
                        // Handle successful login
                        print("Register success: \(response)")
                        username = ""
                        password = ""
                        passwordConfirm = ""
                        isSuccess = true
                        
                    case .failure(let error):
                        // Handle login failure
                        print("Register error: \(error)")
                        // You might want to show an error message to the user here
                    }
                }

            } label: {
                Text("Sign Up")

            }
            .padding(.top, 6)
            .buttonStyle(.bordered)
            .disabled(!passwordsMatch)
        }
    }
}
