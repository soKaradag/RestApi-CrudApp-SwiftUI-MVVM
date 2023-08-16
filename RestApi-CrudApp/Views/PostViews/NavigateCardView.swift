//
//  NavigateCardView.swift
//  RestApi-CrudApp
//
//  Created by Serdar Onur KARADAĞ on 17.08.2023.
//

import SwiftUI

struct NavigateCardView: View {
    private let networkManager = NetworkManager.shared
    
    @EnvironmentObject var postVM: PostViewModel
    
    @Binding var isInProfile: Bool
    
    var post: Post
    
    var body: some View {
        ZStack {
            VStack(alignment: .leading){
                    NavigationLink() {
                        NavigateProfileView(isInProfile: $isInProfile, id: post.userid, username: post.username)
                    } label: {
                        Text("")
                    }
                    .disabled(isInProfile)
                    .opacity(0)
                
                VStack(alignment: .leading) {
                    HStack {
                        Text("@\(post.username)")
                            .font(.system(size: 14, weight: .light))
                        Spacer()
                        
                        if networkManager.currentId == post.userid {
                            Menu {
                                Button {
                                    postVM.deletePost(postId: post.id ?? 0)
                                } label: {
                                    Text("Delete")
                                    Image(systemName: "trash")
                                }
                                
                            } label: {
                                Image(systemName: "ellipsis")
                                    .font(.system(size: 22))
                            }
                        }
                    }
                    
                    HStack {
                        Text(post.title)
                            .font(.system(size: 20, weight: .bold))
                        Spacer()
                        if let createdAt = post.createdAt {
                            VStack {
                                Text(createdAt, format: .dateTime.day().month().year())
                                Text(createdAt, format: .dateTime.hour())
                            }
                            .font(.system(size: 10, weight: .light))
                        } else {
                            Text("N/A")
                                .font(.system(size: 12, weight: .light))
                        }
                    }
                    
                }
                Text(post.content)
                    .padding(.top, 6)
            }
            
        }
    }
}
