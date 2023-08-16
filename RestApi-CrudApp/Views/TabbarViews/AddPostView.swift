//
//  AddPostView.swift
//  RestApi-CrudApp
//
//  Created by Serdar Onur KARADAĞ on 17.08.2023.
//

import SwiftUI

struct AddPostView: View {
    @EnvironmentObject var postVM: PostViewModel
    
    @State private var title: String = ""
    @State private var content: String = ""
    
    @Binding var goToAddView: Bool
    
    @State private var isError: Bool = false
    
    var body: some View {
        VStack {
            Text("ADD POST")
                .font(.system(size: 25, weight: .bold))
            TextField("Title", text: $title)
                .textFieldStyle(.roundedBorder)
                .border(isError ? .red : .clear)
            TextField("Content", text: $content, axis: .vertical)
                .textFieldStyle(.roundedBorder)
                .border(isError ? .red : .clear)
                .lineLimit(10, reservesSpace: true)
            
            Button {
                postVM.addPost(title: title, content: content) { result in
                    switch result {
                    case.success(let response):
                        print("success add post \(response)")
                    case.failure(let error):
                        print("error add post \(error)")
                        isError = true
                    }
                }
                title = ""
                content = ""
                goToAddView = false
            } label: {
                Text("Add Post")
            }
            .buttonStyle(.bordered)

        }
        .padding()
    }
}
