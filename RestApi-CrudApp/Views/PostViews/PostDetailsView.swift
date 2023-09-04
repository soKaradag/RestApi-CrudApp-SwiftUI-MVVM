//
//  PostDetailsView.swift
//  RestApi-CrudApp
//
//  Created by Serdar Onur KARADAĞ on 31.08.2023.
//

import SwiftUI

struct PostDetailsView: View {
    private let networkManager = NetworkManager.shared
    
    @EnvironmentObject var postVM: PostViewModel
    @ObservedObject var likeVM: LikeViewModel
    
    @State private var content: String = ""
    @State private var addComment: Bool = false
    
    @Binding var likeCount: Int
    @Binding var commentFilter: Int
    
    @State private var isLoading: Bool = false
    
    var post: Post
    
    var body: some View {
        
        ScrollView(showsIndicators: false) {
            HStack {
                VStack(alignment: .leading) {
                    Text("@\(post.username)")
                        .font(.system(size: 14, weight: .light))
                    HStack {
                        Text(post.title)
                            .font(.system(size: 18, weight: .bold))
                        Spacer()
                        if let createdAt = post.createdAt {
                            
                            Text(createdAt, format: .dateTime.day().month().year())
                            
                                .font(.system(size: 12, weight: .light))
                        } else {
                            Text("N/A")
                                .font(.system(size: 12, weight: .light))
                        }
                    }
                }
                Spacer()
            }
            
            Text(post.content)
                .font(.system(size: 15))
                .padding(.bottom, 8)

            HStack (alignment: .bottom) {
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
                
                Button {
                    addComment = true
                } label: {
                    VStack(alignment: .center) {
                        Image(systemName: "bubble.right")
                            .font(.system(size: 16))
                        Text("\(post.comments.count ) commend")
                            .font(.system(size: 12))
                    }
                }

                Spacer()
            }

            HStack {
                Text("COMMENTS")
                    .font(.system(size: 20, weight: .bold))
                    .padding(.top, 6)
                Spacer()
                Menu {
                    Button {
                        commentFilter = 0
                    } label: {
                        Text("Latest First")
                    }
                    Button {
                        commentFilter = 1
                    } label: {
                        Text("Oldest First")
                    }
                } label: {
                    Image(systemName: "slider.horizontal.3")
                }
            }
            Divider()
            CommentListView(commentFilter: $commentFilter, post: post)
                .listStyle(.plain)
        }
        .refreshable {
            postVM.fetchPosts()
        }
        .padding()
        .navigationTitle("\(post.comments.count) comments")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            postVM.fetchPosts()
        }
        .sheet(isPresented: $addComment, onDismiss: {
            postVM.fetchPosts()
        }) {
            AddCommentView(addComment: $addComment, post: post)
        }
    }
}

