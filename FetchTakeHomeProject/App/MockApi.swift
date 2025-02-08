//
//  MockApi.swift
//  FetchTakeHomeProject
//
//  Created by Ryan Kanno on 2/7/25.
//

import UIKit

fileprivate let testRecipeHasImageUrl = Recipe(
    cuisine: "Malaysian",
    name: "Apam Balik",
    photoUrlLargeStr: "https://d3jbb8n5wk0qxi.cloudfront.net/photos/b9ab0071-b281-4bee-b361-ec340d405320/large.jpg",
    photoUrlSmallStr: "https://d3jbb8n5wk0qxi.cloudfront.net/photos/b9ab0071-b281-4bee-b361-ec340d405320/small.jpg",
    uuid: "0c6ca6e7-e32a-4053-b824-1dbf749910d8",
    sourceUrlStr: "https://www.nyonyacooking.com/recipes/apam-balik~SJ5WuvsDf9WQ",
    youtubeUrlStr: "https://www.youtube.com/watch?v=6R8ffRRJcrg")

final class MockApi: ApiCallable {
    func fetchData<T: Decodable>(type: T.Type) async throws -> T {
        if CommandLine.arguments.contains("-UITestsHasResults") {
            let dto = RecipesDTO(recipes: [
                testRecipeHasImageUrl,
                testRecipeHasImageUrl
            ])
            return dto as! T
        } else if CommandLine.arguments.contains("-UITestsNoResults") {
            let dto = RecipesDTO(recipes: [])
            return dto as! T
        } else {
            throw URLError(.cannotParseResponse)
        }
    }
    
    func fetchImg(for recipe: Recipe) async throws -> UIImage? {
        return UIImage(systemName: "fork.knife.circle")
    }
}
