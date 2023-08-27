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
    @State private var isRefresh: Bool = false

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
        VStack(alignment: .leading) {
            Text("Test sentence about app.")
                .font(.system(size: 14, weight: .light))
                .padding(.horizontal)
            
            List(sortedPosts) { post in
                // Kullan post değişkenini burada
                let likeVM = LikeViewModel()
                CardView(likeVM: likeVM, post: post)
                    .id(UUID())
            }
            .scrollIndicators(.hidden)
            .listStyle(.plain)
            .onAppear {
                Task {
                    await postVM.fetchPosts()
                }
            }
            .refreshable {
                Task {
                    await postVM.fetchPosts()
                }
            }
        }
        .toolbar {
            Menu("Filter") {
                Button {
                    selectedFilter = 0
                } label: {
                    Text("Latest First")
                }
                Button {
                    selectedFilter = 1
                } label: {
                    Text("Oldest First")
                }
            }
        }
    }
}
