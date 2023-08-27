//
//  HomeView.swift
//  RestApi-CrudApp
//
//  Created by Serdar Onur KARADAĞ on 17.08.2023.
//

import SwiftUI

struct HomeView: View {
    @Binding var currentView: Int
    @State var isSearch: Bool = false
    @State var searchTerm: String = ""
    
    @EnvironmentObject var postVM: PostViewModel
    
    var body: some View {
        VStack {
            if searchTerm .isEmpty {
                PostsListView()
            } else {
                SearchedPostsView(currentView: $currentView, searchTerm: $searchTerm)
            }
            
        }
        .navigationTitle("Home")
        .searchable(text: $searchTerm, placement: .navigationBarDrawer(displayMode: .always) )
    }
}
