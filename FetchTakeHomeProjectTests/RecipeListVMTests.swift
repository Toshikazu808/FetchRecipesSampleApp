//
//  RecipeListVMTests.swift
//  FetchTakeHomeProjectTests
//
//  Created by Ryan Kanno on 2/7/25.
//

import XCTest
@testable import FetchTakeHomeProject

@MainActor final class RecipeListVMTests: XCTestCase {
    func test_lazyInit() throws {
        // setup
        let api = ApiTester()
        let vm = RecipeListVM()
        
        // execute
        vm.lazyInit(api)
        
        // assert
        XCTAssertNotNil(vm.api)
    }
    
    func test_fetchRecipes_noCache() async {
        // setup
        let api = ApiTester()
        let vm = RecipeListVM()
        vm.lazyInit(api)
        
        // execute
        await vm.fetchRecipes()
        
        // assert
        XCTAssertTrue(!vm.recipes.isEmpty)
        XCTAssertEqual(vm.fetchError, false)
    }
    
    func test_fetchRecipes_noResults() async {
        // setup
        let api = ApiTesterNoResults()
        let vm = RecipeListVM()
        vm.lazyInit(api)
        
        // execute
        await vm.fetchRecipes()
        
        // assert
        XCTAssertTrue(vm.recipes.isEmpty)
        XCTAssertEqual(vm.fetchError, false)
    }
    
    func test_fetchImage() async throws {
        // setup
        let api = ApiTester()
        let vm = RecipeListVM()
        vm.lazyInit(api)
        vm.recipes = [testRecipeHasImageUrl, testRecipeHasImageUrl]
        
        // execute
        try await vm.fetchImage(atIndex: 0)
        try await vm.fetchImage(atIndex: 1)
        
        // assert
        XCTAssertNotNil(vm.recipes[0].smallPhoto)
        XCTAssertNotNil(vm.recipes[1].smallPhoto)
    }
}

fileprivate let testRecipeHasImageUrl = Recipe(
    cuisine: "Malaysian",
    name: "Apam Balik",
    photoUrlLargeStr: "https://d3jbb8n5wk0qxi.cloudfront.net/photos/b9ab0071-b281-4bee-b361-ec340d405320/large.jpg",
    photoUrlSmallStr: "https://d3jbb8n5wk0qxi.cloudfront.net/photos/b9ab0071-b281-4bee-b361-ec340d405320/small.jpg",
    uuid: "0c6ca6e7-e32a-4053-b824-1dbf749910d8",
    sourceUrlStr: "https://www.nyonyacooking.com/recipes/apam-balik~SJ5WuvsDf9WQ",
    youtubeUrlStr: "https://www.youtube.com/watch?v=6R8ffRRJcrg")

fileprivate final class ApiTester: ApiCallable {
    func fetchData<T: Decodable>(type: T.Type) async throws -> T {
        let dto = RecipesDTO(recipes: [
            testRecipeHasImageUrl,
            testRecipeHasImageUrl
        ])
        return dto as! T
    }
    
    func fetchImg(for recipe: Recipe) async throws -> UIImage? {
        return UIImage(systemName: "fork.knife.circle")
    }
}

fileprivate final class ApiTesterNoResults: ApiCallable {
    func fetchData<T: Decodable>(type: T.Type) async throws -> T {
        let dto = RecipesDTO(recipes: [])
        return dto as! T
    }
    
    func fetchImg(for recipe: Recipe) async throws -> UIImage? {
        return UIImage(systemName: "fork.knife.circle")
    }
}
