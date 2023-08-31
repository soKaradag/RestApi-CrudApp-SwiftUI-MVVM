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
    
    @State private var isLoading: Bool = false
    @State private var isComments: Bool = false
    @State var commentFilter: Int = 0
    
    var post: Post
    
    var body: some View {
        
        VStack(alignment: .leading){
            
            VStack(alignment: .leading) {
                HStack {
                    Text("@\(post.username)")
                        .font(.system(size: 12, weight: .light))
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
                        .font(.system(size: 16, weight: .bold))
                    Spacer()
                    if let createdAt = post.createdAt {
                        
                        Text(createdAt, format: .dateTime.day().month().year())
                        
                            .font(.system(size: 10, weight: .light))
                    } else {
                        Text("N/A")
                            .font(.system(size: 12, weight: .light))
                    }
                }
                
            }
            
            Text(post.content)
                .font(.system(size: 13))
            
            HStack(alignment: .bottom) {
                VStack(alignment: .center) {
                    Button {
                        
                        isLoading = true
                        if likeVM.isLiked {
                            likeVM.deleteLike(postid: post.id)
                            likeCount -= 1
                        } else {
                            likeVM.addLike(postid: post.id)
                            likeCount += 1
                        }
                        
                        isLoading = false
                        
                        
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
                        .font(.system(size: 12))
                }
                
                NavigationLink {
                    PostDetailsView(likeVM: likeVM, likeCount: $likeCount ,commentFilter: $commentFilter, post: post)
                } label: {
                    VStack(alignment: .center) {
                        Image(systemName: "bubble.right")
                            .font(.system(size: 16))
                        Text("\(post.comments.count ) commend")
                            .font(.system(size: 12))
                    }
                    
                }
                
            }
        }
        .onAppear {
            likeVM.checkIfLiked(post: post)
            likeCount = post.likes?.count ?? 0
        }
    }
    
}
