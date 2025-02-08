//
//  RecipeVideoView.swift
//  FetchTakeHomeProject
//
//  Created by Ryan Kanno on 2/7/25.
//

import SwiftUI
import WebKit

struct RecipeVideoView: View {
    let recipe: Recipe
    
    var body: some View {
        if let url = recipe.youtubeUrl {
            YoutubeView(url: url)
        } else {
            Text("Video unavailable")
        }
    }
}

struct YoutubeView: UIViewRepresentable {
    let url: URL
    
    func makeUIView(context: Context) -> WKWebView {
        return WKWebView()
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        uiView.load(URLRequest(url: url))
    }
}

#Preview {
    RecipeVideoView(recipe: Recipe(cuisine: "Malaysian", name: "Apam Balik", photoUrlLargeStr: "https://d3jbb8n5wk0qxi.cloudfront.net/photos/b9ab0071-b281-4bee-b361-ec340d405320/large.jpg", photoUrlSmallStr: "https://d3jbb8n5wk0qxi.cloudfront.net/photos/b9ab0071-b281-4bee-b361-ec340d405320/small.jpg", uuid: "0c6ca6e7-e32a-4053-b824-1dbf749910d8", sourceUrlStr: "https://www.nyonyacooking.com/recipes/apam-balik~SJ5WuvsDf9WQ", youtubeUrlStr: "https://www.youtube.com/watch?v=6R8ffRRJcrg"))
}
