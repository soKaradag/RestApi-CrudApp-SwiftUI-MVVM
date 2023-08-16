//
//  RestApi_CrudAppApp.swift
//  RestApi-CrudApp
//
//  Created by Serdar Onur KARADAĞ on 17.08.2023.
//

import SwiftUI

@main
struct RestApi_CrudAppApp: App {
    
    @StateObject var userVM = UserViewModel()
    @StateObject var postVM = PostViewModel()
    @StateObject var authVM = LoginViewModel()
    @StateObject var registerVM = RegisterViewModel()
    @StateObject private var searchVM = SearchViewModel()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(userVM)
                .environmentObject(postVM)
                .environmentObject(authVM)
                .environmentObject(registerVM)
                .environmentObject(searchVM)
        }
    }
}
