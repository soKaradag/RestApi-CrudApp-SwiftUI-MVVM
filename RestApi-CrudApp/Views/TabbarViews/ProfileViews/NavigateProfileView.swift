//
//  NavigateProfileView.swift
//  RestApi-CrudApp
//
//  Created by Serdar Onur KARADAĞ on 17.08.2023.
//

import SwiftUI

struct NavigateProfileView: View {
    private let networkManager = NetworkManager.shared
    
    @EnvironmentObject var postVM: PostViewModel
    
    @State private var selectedFilter: Int = 0
    @Binding var isInProfile: Bool
    
    var sortedPosts: [Post] {
        switch selectedFilter {
        case 0:
            return postVM.userPosts.sorted { $0.createdAt ?? Date() > $1.createdAt ?? Date() }
        case 1:
            return postVM.userPosts.sorted { $0.createdAt ?? Date() < $1.createdAt ?? Date() }
        default:
            return postVM.posts
        }
    }
    
    var id: Int
    var username: String
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("This user has \(sortedPosts.count) posts.")
                .font(.system(size: 14, weight: .light))
                .padding(.horizontal)
            
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
        }
        .onAppear {
            isInProfile = true
            postVM.fetchUserPost(profileId: id)
        }
        .navigationTitle(username)
        .refreshable {
            postVM.fetchUserPost(profileId: id)
        }

        
    }
}
