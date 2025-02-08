//
//  ApiTests.swift
//  ApiTests
//
//  Created by Ryan Kanno on 2/7/25.
//

import XCTest
import Foundation
@testable import FetchTakeHomeProject

final class ApiTests: XCTestCase {
    func test_constructURL_valid() {
        // setup
        let api = Api()
        let sampleUrl = "https://d3jbb8n5wk0qxi.cloudfront.net/recipes.json"
        
        // execute
        let url = api.constructURL(RecipesDTO.self)
        
        // assert
        guard let urlStr = url?.absoluteString else {
            XCTFail()
            return
        }
        XCTAssertEqual(sampleUrl, urlStr)
    }
    
    func test_constructURL_invalid() {
        // setup
        let api = Api()
        
        // execute
        let url = api.constructURL(String.self)
        
        // assert
        XCTAssertNil(url)
    }
    
    func test_fetchData_RecipesDTO() async throws {
        // setup
        let api = Api()
        
        // execute
        XCTAssertNoThrow({
            let _ = try await api.fetchData(type: RecipesDTO.self)
        })
    }
    
    func test_fetchImg_valid() async throws {
        // setup
        let api = Api()
        let recipe = Recipe(
            cuisine: "Malaysian",
            name: "Apam Balik",
            photoUrlLargeStr: "https://d3jbb8n5wk0qxi.cloudfront.net/photos/b9ab0071-b281-4bee-b361-ec340d405320/large.jpg",
            photoUrlSmallStr: "https://d3jbb8n5wk0qxi.cloudfront.net/photos/b9ab0071-b281-4bee-b361-ec340d405320/small.jpg",
            uuid: "0c6ca6e7-e32a-4053-b824-1dbf749910d8",
            sourceUrlStr: "https://www.nyonyacooking.com/recipes/apam-balik~SJ5WuvsDf9WQ",
            youtubeUrlStr: "https://www.youtube.com/watch?v=6R8ffRRJcrg")
        
        // execute
        XCTAssertNoThrow({
            let img = try await api.fetchImg(for: recipe)
            XCTAssertNotNil(img)
        })
    }
    
    func test_fetchImg_invalid() async throws {
        // setup
        let api = Api()
        let recipe = Recipe(
            cuisine: "Malaysian",
            name: "Apam Balik",
            photoUrlLargeStr: nil,
            photoUrlSmallStr: nil,
            uuid: "0c6ca6e7-e32a-4053-b824-1dbf749910d8",
            sourceUrlStr: "https://www.nyonyacooking.com/recipes/apam-balik~SJ5WuvsDf9WQ",
            youtubeUrlStr: "https://www.youtube.com/watch?v=6R8ffRRJcrg")
        
        // execute
        let img = try await api.fetchImg(for: recipe)
        
        // assert
        XCTAssertNil(img)
    }
}
