//
//  ContentView.swift
//  RestApi-CrudApp
//
//  Created by Serdar Onur KARADAĞ on 17.08.2023.
//

import SwiftUI

struct ContentView: View {
    private let networkManager = NetworkManager.shared
    
    @EnvironmentObject var authVM: LoginViewModel
    
    @State var currentView: Int = 1
    @State var isInProfile: Bool = false
    
    @AppStorage("COLOR_THEME") var colorTheme: Bool = false
    
    var body: some View {
        if authVM.isLoggedIn {
            NavigationStack {
                VStack {
                    if currentView == 1 {
                        HomeView(currentView: $currentView, isInProfile: $isInProfile)
                    } else if currentView == 2 {
                        ProfileView(currentView: $currentView, id: networkManager.currentId)
                    } else {
                        HomeView(currentView: $currentView, isInProfile: $isInProfile)
                    }
                    
                 Spacer()
                    
                    TabbarView(currentView: $currentView)
                }
                .preferredColorScheme(colorTheme ? .dark : .light)
                
            }
            .accentColor(.primary)
        } else {
            LoginRegisterView()
        }
    }
}
