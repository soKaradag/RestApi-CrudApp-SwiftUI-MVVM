//
//  LoginRegisterView.swift
//  RestApi-CrudApp
//
//  Created by Serdar Onur KARADAĞ on 17.08.2023.
//

import SwiftUI

struct LoginRegisterView: View {
    private let networkManager = NetworkManager.shared
    
    @State private var isApprove: Bool = false
    @State private var isAuthLogin: Bool = true
    
    @State var isSuccess: Bool = false
    
    var body: some View {
        if isAuthLogin {
            VStack(alignment: .center) {
                Text("Login to continue")
                    .font(.system(size: 20, weight: .bold))
                    .padding(.vertical)
                Text("Welcome to the blog.")
                    .font(.system(size: 14, weight: .thin))
                    .padding(.bottom)
                
                LoginView()
                    .padding(.horizontal)
                
                HStack {
                    Text("Don't you have an account?")
                    Button {
                        isAuthLogin = false
                    } label: {
                        Text("Sign Up")
                    }

                }
                .padding(.top, 10)
            }
        } else {
            
            VStack(alignment: .center) {
                VStack {
                    Image(systemName: "checkmark.circle")
                        .font(.system(size: 50))
                        .padding(.bottom, 10)
                    Text("Registered successfuly")
                        .font(.system(size: 18))
                }
                .foregroundColor(.green)
                .opacity(isSuccess ? 1 : 0)
                
                Text("Create an account to continue")
                    .font(.system(size: 20, weight: .bold))
                    .padding(.vertical)
                Text("By continuing, you agree to our User Agreement and acknowledge that you understand the Privacy Policy.")
                    .font(.system(size: 14, weight: .thin))
                    .padding(.bottom)
                    .padding(.bottom)
                
                RegisterView(isSuccess: $isSuccess)
                    .padding(.horizontal)
                
                HStack {
                    if isApprove {
                        Button {
                            isApprove.toggle()
                        } label: {
                            Image(systemName: "checkmark.square")
                        }

                    } else {
                        Button {
                            isApprove.toggle()
                        } label: {
                            Image(systemName: "square")
                        }

                    }
                    Text("I agree to get emails about cool stuff on Blog")
                }
                .font(.system(size: 16, weight: .thin))
                .padding(.bottom)
                .padding(.top, 6)
                
                HStack {
                    Text("Already have an account?")
                    Button {
                        isAuthLogin = true
                        isSuccess = false
                    } label: {
                        Text("Log in")
                    }

                }
            }
        }
    }
}
