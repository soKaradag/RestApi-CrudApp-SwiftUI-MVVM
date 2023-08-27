//
//  ProfileView.swift
//  RestApi-CrudApp
//
//  Created by Serdar Onur KARADAĞ on 17.08.2023.
//

import SwiftUI

struct ProfileView: View {
    private let networkManager = NetworkManager.shared
    
    @EnvironmentObject var postVM: PostViewModel
    @EnvironmentObject var likeVM: LikeViewModel
    
    @State var isPresentAuth: Bool = false
    
    @Binding var currentView: Int
    
    @State private var selectedFilter: Int = 0
    
    var sortedPosts: [Post] {
        switch selectedFilter {
        case 0:
            return postVM.userPosts.sorted { $0.createdAt ?? Date() > $1.createdAt ?? Date() }
        case 1:
            return postVM.userPosts.sorted { $0.createdAt ?? Date() < $1.createdAt ?? Date() }
        default:
            return postVM.userPosts
        }
    }
    
    var id: Int
    
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
                CardView(post: post)
            }
            .scrollIndicators(.hidden)
            .listStyle(.plain)
            .onAppear {
                Task {
                    postVM.fetchUserPost(profileId: networkManager.currentId)
                }
            }
        }
        .navigationTitle(networkManager.currentUsername)
        .toolbar {
            Button {
                isPresentAuth = true
            } label: {
                Image(systemName: "gearshape")
            }

        }
        .sheet(isPresented: $isPresentAuth) {
            NavigationView {
                SettingsView(currentView: $currentView, isPresentAuth: $isPresentAuth)
            }
        }
        .refreshable {
            Task {
                postVM.fetchUserPost(profileId: networkManager.currentId)
            }
        }
    }
}
