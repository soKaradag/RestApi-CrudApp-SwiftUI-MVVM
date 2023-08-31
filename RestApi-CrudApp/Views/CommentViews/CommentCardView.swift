//
//  CommentCardView.swift
//  RestApi-CrudApp
//
//  Created by Serdar Onur KARADAĞ on 31.08.2023.
//

import SwiftUI

struct CommentCardView: View {
    var comment: Comment
    
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
            }
            Text(comment.content ?? "unkown")
                .font(.system(size: 13))
            Divider()
        }
    }
}
