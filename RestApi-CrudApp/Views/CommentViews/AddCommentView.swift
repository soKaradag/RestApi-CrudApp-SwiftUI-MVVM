//
//  AddCommentView.swift
//  RestApi-CrudApp
//
//  Created by Serdar Onur KARADAĞ on 31.08.2023.
//

import SwiftUI

struct AddCommentView: View {
    @EnvironmentObject var commentVM: CommentViewModel
    @State private var content: String = ""
    
    var post: Post
    
    var body: some View {
        VStack {
            Text("ADD Comment")
                .font(.system(size: 25, weight: .bold))
            
            TextField("Content", text: $content, axis: .vertical)
                .textFieldStyle(.roundedBorder)
                .lineLimit(5, reservesSpace: true)
            
            Button {
                
                    commentVM.addComment(postid: post.id, content: content)
                
            } label: {
                Text("Add Comment")
            }
            .buttonStyle(.bordered)

        }
        .padding()
    }
}

