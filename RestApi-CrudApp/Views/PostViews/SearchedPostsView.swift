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
    @State var searchTerm: String = ""
    
    var body: some View {
        VStack {
            if searchTerm.isEmpty {
                Text("No Post.")
                    .font(.system(size: 22))
                    .foregroundColor(.secondary)
            } else {
                List(searchVM.searchResults.sorted { $0.createdAt ?? Date() > $1.createdAt ?? Date() }) { post in
                    CardView(post: post)
                }
                .scrollIndicators(.hidden)
                .listStyle(.plain)
            }
        }
        .onAppear {
            searchVM.searchPosts(searchTerm: searchTerm)
        }
        .onChange(of: searchTerm) { newSearchTerm in
            searchVM.searchPosts(searchTerm: searchTerm)
        }
        .searchable(text: $searchTerm, placement: .navigationBarDrawer(displayMode: .always) )
        .navigationTitle("Search")
    }

}
