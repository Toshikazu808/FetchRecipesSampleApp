//
//  RecipeListNavPath.swift
//  FetchTakeHomeProject
//
//  Created by Ryan Kanno on 2/7/25.
//

import Foundation

enum RecipeListNavPath: Hashable {
    case video(Recipe)
}

extension [RecipeListNavPath] {
    mutating func popToRoot() {
        self = []
    }
}
