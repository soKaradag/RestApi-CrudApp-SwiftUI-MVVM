//
//  PostsListView.swift
//  RestApi-CrudApp
//
//  Created by Serdar Onur KARADAĞ on 17.08.2023.
//

import SwiftUI

struct PostsListView: View {
    @EnvironmentObject var postVM: PostViewModel

    
    @State private var selectedFilter: Int = 0
    @Binding var isInProfile: Bool
    
    var sortedPosts: [Post] {
        switch selectedFilter {
        case 0:
            return postVM.posts.sorted { $0.createdAt ?? Date() > $1.createdAt ?? Date() }
        case 1:
            return postVM.posts.sorted { $0.createdAt ?? Date() < $1.createdAt ?? Date() }
        default:
            return postVM.posts
        }
    }
    
    var body: some View {
        VStack {
            Picker("Sort Order", selection: $selectedFilter) {
                 Text("Latest First").tag(0)
                 Text("Oldest First").tag(1)
             }
             .pickerStyle(SegmentedPickerStyle())
             .padding(.horizontal)
            
            List(sortedPosts) { post in
                NavigateCardView(isInProfile: $isInProfile, post: post)
            }
            .scrollIndicators(.hidden)
            .listStyle(.plain)
            .onAppear {
                postVM.fetchPosts()
            }
            .refreshable {
                postVM.fetchPosts()
            }
        }
    }
}
