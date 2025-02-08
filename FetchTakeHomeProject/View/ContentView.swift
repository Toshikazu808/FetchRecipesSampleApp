//
//  ContentView.swift
//  FetchTakeHomeProject
//
//  Created by Ryan Kanno on 2/6/25.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @StateObject private var recipeListVM: RecipeListVM
    
    init(_ modelContext: ModelContext) {
        let vm = RecipeListVM()
        vm.setModelContext(modelContext: modelContext)
        self._recipeListVM = StateObject(wrappedValue: vm)
    }
    
    var body: some View {
        NavigationStack(path: $recipeListVM.navPath) {
            RecipeListView()
                .environmentObject(recipeListVM)
                .navigationBarTitleDisplayMode(.inline)
                .navigationTitle("Recipes")
                .navigationDestination(for: RecipeListNavPath.self) { path in
                    switch path {
                    case .video(let recipe):
                        RecipeVideoView(recipe: recipe)
                            .navigationBarTitleDisplayMode(.inline)
                            .navigationTitle(recipe.name)
                    }
                }
        }
    }
}

#Preview {
    ContentView(try! ModelContainer(for: CachedRecipe.self).mainContext)
}
