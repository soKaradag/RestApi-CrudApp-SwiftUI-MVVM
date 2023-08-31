//
//  CommentListView.swift
//  RestApi-CrudApp
//
//  Created by Serdar Onur KARADAĞ on 31.08.2023.
//

import SwiftUI

struct CommentListView: View {
    @EnvironmentObject var postVM: PostViewModel
    
    var post: Post
    
    var body: some View {
        VStack {
            ForEach(post.comments) {comment in
                CommentCardView(comment: comment)
            }
        }
    }
}
