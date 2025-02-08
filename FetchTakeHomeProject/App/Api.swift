//
//  Api.swift
//  FetchTakeHomeProject
//
//  Created by Ryan Kanno on 2/6/25.
//

import UIKit

protocol ApiCallable {
    func fetchData<T: Decodable>(type: T.Type) async throws -> T
    func fetchImg(for recipe: Recipe) async throws -> UIImage?
}

final class Api: ApiCallable {
    func fetchData<T: Decodable>(type: T.Type) async throws -> T {
        guard let url = constructURL(type) else {
            throw URLError(.badURL)
        }
        let data = try await performFetch(from: url)
        let decodedData = try JSONDecoder().decode(T.self, from: data)
        return decodedData
    }
    
    func fetchImg(for recipe: Recipe) async throws -> UIImage? {
        guard let url = recipe.smallPhotoUrl else {
            return nil
        }
        let data = try await performFetch(from: url)
        return UIImage(data: data)
    }
    
    func constructURL<T>(_ type: T.Type) -> URL? {
        switch type {
        case is RecipesDTO.Type:
            var components = URLComponents()
            components.scheme = "https"
            components.host = "d3jbb8n5wk0qxi.cloudfront.net"
            components.path = "/recipes.json"
            return components.url
        default:
            return nil
        }
    }
    
    func performFetch(from url: URL) async throws -> Data {
        let session = URLSession.shared
        let (data, response) = try await session.data(from: url)
        guard let r = response as? HTTPURLResponse else {
            throw URLError(.cannotParseResponse)
        }
        guard r.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }
        return data
    }
}
