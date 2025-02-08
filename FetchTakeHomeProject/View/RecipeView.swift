//
//  RecipeView.swift
//  FetchTakeHomeProject
//
//  Created by Ryan Kanno on 2/6/25.
//

import SwiftUI

struct RecipeView: View {
    @EnvironmentObject private var vm: RecipeListVM
    let recipe: Recipe
    let maxHeight: CGFloat
    
    var body: some View {
        HStack(alignment: .center) {
            VStack(alignment: .leading, spacing: 10) {
                Text(recipe.name)
                    .foregroundStyle(.primary)
                    .accessibilityIdentifier("RecipeName: \(recipe.index ?? -1)")
                
                Text(recipe.cuisine)
                    .foregroundStyle(.primary)
                    .accessibilityIdentifier("RecipeCuisine: \(recipe.index ?? -1)")
            }
            
            Spacer()
            
            if let img = recipe.smallPhoto {
                Image(uiImage: img)
                    .formatImage(maxHeight: maxHeight)
            } else {
                Image(systemName: "fork.knife.circle")
                    .formatImage(maxHeight: maxHeight)
            }
        }
        .padding(.horizontal)
        .padding(.vertical, 5)
        .onAppear {
            Task {
                try await vm.fetchImage(atIndex: recipe.index)
            }
        }
        .onDisappear {
            vm.cacheRecipe(recipe)
        }
    }
}

#Preview {
    RecipeView(recipe: Recipe(cuisine: "Malaysian", name: "Apam Balik", photoUrlLargeStr: "https://d3jbb8n5wk0qxi.cloudfront.net/photos/b9ab0071-b281-4bee-b361-ec340d405320/large.jpg", photoUrlSmallStr: "https://d3jbb8n5wk0qxi.cloudfront.net/photos/b9ab0071-b281-4bee-b361-ec340d405320/small.jpg", uuid: "0c6ca6e7-e32a-4053-b824-1dbf749910d8", sourceUrlStr: "https://www.nyonyacooking.com/recipes/apam-balik~SJ5WuvsDf9WQ", youtubeUrlStr: "https://www.youtube.com/watch?v=6R8ffRRJcrg"), maxHeight: 110)
}
