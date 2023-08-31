//
//  RestApi_CrudAppApp.swift
//  RestApi-CrudApp
//
//  Created by Serdar Onur KARADAĞ on 17.08.2023.
//

import SwiftUI

@main
struct BlogRestApiApp: App {
    @StateObject var userVM = UserViewModel()
    @StateObject var postVM = PostViewModel()
    @StateObject var authVM = LoginViewModel()
    @StateObject var registerVM = RegisterViewModel()
    @StateObject var searchVM = SearchViewModel()
    @StateObject var likeVM = LikeViewModel()
    @StateObject var commentVM = CommentViewModel()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(userVM)
                .environmentObject(postVM)
                .environmentObject(authVM)
                .environmentObject(registerVM)
                .environmentObject(searchVM)
                .environmentObject(likeVM)
                .environmentObject(commentVM)
        }
    }
}
