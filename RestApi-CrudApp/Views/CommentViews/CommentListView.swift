//
//  CommentListView.swift
//  RestApi-CrudApp
//
//  Created by Serdar Onur KARADAĞ on 31.08.2023.
//

import SwiftUI

struct CommentListView: View {
    @EnvironmentObject var postVM: PostViewModel
    
    @Binding var commentFilter: Int
    
    @State var post: Post
    
    var sortedComments: [Comment] {
        switch commentFilter {
        case 0:
            return post.comments.sorted { $0.createdAt ?? Date() > $1.createdAt ?? Date() }
        case 1:
            return post.comments.sorted { $0.createdAt ?? Date() < $1.createdAt ?? Date() }
        default:
            return post.comments
        }
    }
    
    var body: some View {
        VStack {
            ForEach(sortedComments) {comment in
                CommentCardView(comment: comment, post: post)
            }
        }
    }
}
