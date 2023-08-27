//
//  PostCardView.swift
//  RestApi-CrudApp
//
//  Created by Serdar Onur KARADAĞ on 17.08.2023.
//

import SwiftUI

struct CardView: View {
    private let networkManager = NetworkManager.shared
    
    @EnvironmentObject var postVM: PostViewModel
    @StateObject var likeVM = LikeViewModel()
    
    @State private var isShowsLikes: Bool = false
    @State private var likeButtonTapped: Bool = false
    @State private var likeCount: Int = 0
    
    @State private var isLoading = false
    
    var post: Post
    
    var body: some View {
        
        VStack(alignment: .leading){
            
            VStack(alignment: .leading) {
                HStack {
                    Text("@\(post.username)")
                        .font(.system(size: 14, weight: .light))
                    Spacer()
                    
                    if networkManager.currentId == post.userid {
                        Menu {
                            Button {
                                postVM.deletePost(postId: post.id )
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
                .padding(.vertical, 12)
            
            VStack(alignment: .center) {
                Button {
                    Task {
                        isLoading = true
                        if likeVM.isLiked {
                            await likeVM.deleteLike(postid: post.id)
                            likeCount -= 1
                        } else {
                            await likeVM.addLike(postid: post.id)
                            likeCount += 1
                        }

                        isLoading = false
                    }

                } label: {
                    if likeVM.isLiked {
                        Image(systemName: "heart.fill")
                            .foregroundColor(.red)
                    } else {
                        Image(systemName: "heart")
                    }
                }
                .buttonStyle(.borderless)
                
                Text("\(likeCount) liked")
                
            }
        }
        .onAppear {
            likeVM.checkIfLiked(post: post)
            likeCount = post.likes?.count ?? 0
        }
    }
    
}
