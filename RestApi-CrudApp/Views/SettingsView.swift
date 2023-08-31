//
//  SettingsView.swift
//  RestApi-CrudApp
//
//  Created by Serdar Onur KARADAĞ on 17.08.2023.
//

import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var authVM: LoginViewModel
    @EnvironmentObject var userVM: UserViewModel
    
    @Binding var currentView: Int
    @Binding var isPresentAuth: Bool
    
    @AppStorage("COLOR_THEME") var colorTheme: Bool = false
    
    var body: some View {
        VStack {
            Form {
                Button {
                    isPresentAuth = false
                } label: {
                    Text("Close")
                }

                Section {
                    Button {
                        authVM.logout { result in
                             switch result {
                             case .success(let response):
                                 // Handle successful logout response here
                                 print("Logout successful: \(response)")
                                 DispatchQueue.main.async {
                                     authVM.isLoggedIn = false
                                     currentView = 1
                                 }
                             case .failure(let error):
                                 // Handle logout failure here
                                 print("Logout failed: \(error)")
                             }
                         }
                        authVM.handleSuccessfulLogout()
                        
                    } label: {
                        Text("Logout")
                    }
                } header: {
                    Text("Logout")
                }

                
                Section {
                    Button {
                        userVM.deleteUser()
                        DispatchQueue.main.async {
                            authVM.isLoggedIn = false
                            currentView = 1
                        }
                    } label: {
                        Text("Delete User")
                    }
                } header: {
                    Text("Delete User")
                }
                
                Section {
                    Toggle("Change Theme", isOn: $colorTheme )
                } header: {
                    Text("THEME SETTINGS")
                }


            }

        }
    }
}

