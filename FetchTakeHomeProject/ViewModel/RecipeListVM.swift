//
//  RecipeListVM.swift
//  FetchTakeHomeProject
//
//  Created by Ryan Kanno on 2/6/25.
//

import UIKit
import SwiftData

/// NOTE: If this class didn't need to hold a reference to `ModelContext` for SwiftData, I would've opted to mark this class with the `@Observable` property wrapper from the `Observation` framework.
/// However, `ModelContext` currently doesn't play nicely with `@Observable`, which is why I opted to use `ObservableObject`.
@MainActor final class RecipeListVM: ObservableObject {
    private(set) var api: ApiCallable!
    private(set) var modelContext: ModelContext!
    @Published var navPath: [RecipeListNavPath] = []
    @Published var recipes: [Recipe]  = []
    private var viewDidLoad = false
    @Published var fetchError = false
    
    /// > Important: This function should be called only once immediately after initialization.
    /// This function extracts injecting the `ModelContext` from the initializer for easier unit testing.
    func setModelContext(modelContext: ModelContext) {
        self.modelContext = modelContext
        self.modelContext!.autosaveEnabled = false
    }
    
    /// > Important: This function should be called only once immediately after initialization.
    /// This function is used to inject an `ApiCallable` dependency which is stored in the `AppDelegate` environment object.
    /// This must be injected after the `init()` is called since the view model won't have access to the environment object `self.appDelegate` upon initialization.
    func lazyInit(_ api: ApiCallable) {
        guard !viewDidLoad else { return }
        self.api = api
        viewDidLoad = true
    }
    
    func fetchRecipes() async {
        guard recipes.isEmpty else { return }
        let cachedRecipes = fetchCachedRecipes()
        if cachedRecipes.isEmpty {
            do {
                let dto = try await api.fetchData(type: RecipesDTO.self)
                recipes = dto.recipes.enumerated().map({ i, recipe in
                    var recipe = recipe
                    recipe.index = i
                    return recipe
                })
                cacheRecipes()
            } catch {
                fetchError = true
            }
        } else {
            recipes = cachedRecipes.map({ Recipe($0) })
        }
    }
    
    private func cacheRecipes() {
        let recipes = recipes.map({ CachedRecipe($0) })
        do {
            try modelContext?.transaction {
                recipes.forEach {
                    modelContext?.insert($0)
                }
                try modelContext?.save()
            }
        } catch {
            print("Failed to cache recipes.")
        }
    }
    
    func cacheRecipe(_ recipe: Recipe) {
        let recipeToCache = CachedRecipe(recipe)
        if let currentlyCachedRecipe = fetchCachedRecipe(recipe), currentlyCachedRecipe != recipeToCache {
            do {
                try removeOldRecipe(currentlyCachedRecipe)
                try modelContext?.transaction {
                    modelContext?.insert(recipeToCache)
                    try modelContext?.save()
                }
            } catch {
                print("ModelContext transaction failed.")
            }
        }
    }
    
    private func removeOldRecipe(_ recipe: CachedRecipe) throws {
        try modelContext?.transaction {
            modelContext?.delete(recipe)
            try modelContext?.save()
        }
    }
    
    func fetchImage(atIndex i: Int?) async throws {
        guard let i else { return }
        let recipe = recipes[i]
        guard recipe.smallPhoto == nil else { return }
        if let img = try await api.fetchImg(for: recipe) {
            recipes[i].smallPhoto = img
            cacheRecipe(recipes[i])
        }
    }
    
    private func fetchCachedRecipe(_ recipe: Recipe) -> CachedRecipe? {
        let id = recipe.id
        do {
            let descriptor = FetchDescriptor<CachedRecipe>(predicate: #Predicate { $0.id == id })
            let cachedRecipes = try modelContext?.fetch(descriptor)
            guard let cachedRecipe = cachedRecipes?.first else {
                return nil
            }
            return cachedRecipe
        } catch {
            return nil
        }
    }
    
    // NOTE: The caching schema assumes that we will only ever fetch the same data given the online instructions.
    private func fetchCachedRecipes() -> [CachedRecipe] {
        if CommandLine.arguments.contains("-UITestsNoResults") {
            return []
        }
        do {
            let descriptor = FetchDescriptor<CachedRecipe>(sortBy: [SortDescriptor(\.index)])
            guard let recipes = try modelContext?.fetch(descriptor) else {
                return []
            }
            return recipes
        } catch {
            print(error.localizedDescription)
            return []
        }
    }
}
