//
//  CommentCardView.swift
//  RestApi-CrudApp
//
//  Created by Serdar Onur KARADAĞ on 31.08.2023.
//

import SwiftUI

struct CommentCardView: View {
    private let networkManager = NetworkManager.shared
    
    @EnvironmentObject var commentVM: CommentViewModel
    
    @State var comment: Comment
    @State var post: Post
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("@\(comment.username ?? "unkown")")
                    .font(.system(size: 12, weight: .light))
                Spacer()
                if let createdAt = comment.createdAt {
                    
                    Text(createdAt, format: .dateTime.day().month().year())
                    
                        .font(.system(size: 10, weight: .light))
                } else {
                    Text("N/A")
                        .font(.system(size: 10, weight: .light))
                }
                
                if (comment.userid == networkManager.currentId) || (post.userid == networkManager.currentId) {
                    Menu {
                        Button(action: {
                            Task {
                                await commentVM.deleteComment(commentId: comment.id ?? 0)
                            }
                        }) {
                            Text("Delete")
                        }
                    } label: {
                        Image(systemName: "ellipsis")
                    }
                }
                
            }
            Text(comment.content ?? "unkown")
                .font(.system(size: 13))
            Divider()
        }
    }
}
