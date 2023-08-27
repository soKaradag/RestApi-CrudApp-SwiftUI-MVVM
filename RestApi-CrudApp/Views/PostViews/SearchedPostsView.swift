//
//  SearchedPostsView.swift
//  RestApi-CrudApp
//
//  Created by Serdar Onur KARADAĞ on 17.08.2023.
//

import SwiftUI

struct SearchedPostsView: View {
    @EnvironmentObject var searchVM: SearchViewModel
    @EnvironmentObject var likeVM: LikeViewModel
    
    @Binding var currentView: Int
    @Binding var searchTerm: String
    
    var body: some View {
        VStack {
            List(searchVM.searchResults.sorted { $0.createdAt ?? Date() > $1.createdAt ?? Date() }) { post in
                CardView(post: post)
            }
            .scrollIndicators(.hidden)
            .listStyle(.plain)
        }
        .onAppear {
            searchPosts()
        }
        .onChange(of: searchTerm) { newSearchTerm in
            searchPosts()
        }
    }
    
    private func searchPosts() {
        // Call the searchPosts function in the SearchViewModel
        searchVM.searchPosts(searchTerm: searchTerm) { result in
            // Handle search result if needed
        }
    }
}
