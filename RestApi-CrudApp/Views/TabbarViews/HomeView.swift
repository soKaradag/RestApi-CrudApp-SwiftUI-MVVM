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
    
    @EnvironmentObject var postVM: PostViewModel
    
    var body: some View {
        VStack {
            NavigationLink {
                SearchedPostsView(currentView: $currentView)
            } label: {
                HStack {
                    Image(systemName: "magnifyingglass")
                    Text("Search")
                    Spacer()
                }
                .font(.system(size: 14, weight: .light))
                .foregroundColor(.secondary)
                
            }
            .buttonStyle(.bordered)
            .padding(.horizontal)
            
            PostsListView()

        }
        .navigationTitle("Home")
    }
}
