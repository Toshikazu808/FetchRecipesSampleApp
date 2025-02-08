//
//  Recipes.swift
//  FetchTakeHomeProject
//
//  Created by Ryan Kanno on 2/6/25.
//

import UIKit
import SwiftData

struct RecipesDTO: Decodable, Hashable {
    let recipes: [Recipe]
}

struct Recipe: Decodable, Hashable, Identifiable {
    let cuisine: String
    let name: String
    let photoUrlLargeStr: String?
    let photoUrlSmallStr: String?
    let id: String
    let sourceUrlStr: String?
    let youtubeUrlStr: String?
    
    var largePhotoUrl: URL? {
        guard let photoUrlLargeStr else { return nil }
        return URL(string: photoUrlLargeStr)
    }
    var largePhoto: UIImage?
    
    var smallPhotoUrl: URL? {
        guard let photoUrlSmallStr else { return nil }
        return URL(string: photoUrlSmallStr)
    }
    var smallPhoto: UIImage?
    
    var sourceUrl: URL? {
        guard let sourceUrlStr else { return nil }
        return URL(string: sourceUrlStr)
    }
    var youtubeUrl: URL? {
        guard let youtubeUrlStr else { return nil }
        return URL(string: youtubeUrlStr)
    }
    
    var index: Int?
    
    enum CodingKeys: String, CodingKey {
        case cuisine = "cuisine"
        case name = "name"
        case photoUrlLargeStr = "photo_url_large"
        case photoUrlSmallStr = "photo_url_small"
        case id = "uuid"
        case sourceUrlStr = "source_url"
        case youtubeUrlStr = "youtube_url"
    }
    
    init(cuisine: String, name: String, photoUrlLargeStr: String?, photoUrlSmallStr: String?, uuid: String, sourceUrlStr: String?, youtubeUrlStr: String?, largePhoto: UIImage? = nil, smallPhoto: UIImage? = nil) {
        self.cuisine = cuisine
        self.name = name
        self.photoUrlLargeStr = photoUrlLargeStr
        self.photoUrlSmallStr = photoUrlSmallStr
        self.id = uuid
        self.sourceUrlStr = sourceUrlStr
        self.youtubeUrlStr = youtubeUrlStr
        self.largePhoto = largePhoto
        self.smallPhoto = smallPhoto
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        cuisine = try container.decode(String.self, forKey: .cuisine)
        name = try container.decode(String.self, forKey: .name)
        photoUrlLargeStr = try container.decodeIfPresent(String.self, forKey: .photoUrlLargeStr)
        photoUrlSmallStr = try container.decodeIfPresent(String.self, forKey: .photoUrlSmallStr)
        id = try container.decode(String.self, forKey: .id)
        sourceUrlStr = try container.decodeIfPresent(String.self, forKey: .sourceUrlStr)
        youtubeUrlStr = try container.decodeIfPresent(String.self, forKey: .youtubeUrlStr)
    }
    
    init(_ cachedRecipe: CachedRecipe) {
        id = cachedRecipe.id
        cuisine = cachedRecipe.cuisine
        name = cachedRecipe.name
        photoUrlLargeStr = cachedRecipe.photoUrlLargeStr
        photoUrlSmallStr = cachedRecipe.photoUrlSmallStr
        sourceUrlStr = cachedRecipe.sourceUrlStr
        youtubeUrlStr = cachedRecipe.youtubeUrlStr
        if let data = cachedRecipe.smallImgData {
            smallPhoto = UIImage(data: data)
        }
        if let data = cachedRecipe.largeImgData {
            largePhoto = UIImage(data: data)
        }
        index = cachedRecipe.index
    }
    
    static func == (lhs: Recipe, rhs: Recipe) -> Bool {
        return lhs.id == rhs.id
        && lhs.cuisine == rhs.cuisine
        && lhs.name == rhs.name
        && lhs.photoUrlLargeStr == rhs.photoUrlLargeStr
        && lhs.photoUrlSmallStr == rhs.photoUrlSmallStr
        && lhs.sourceUrlStr == rhs.sourceUrlStr
        && lhs.youtubeUrlStr == rhs.youtubeUrlStr
        && lhs.largePhoto == rhs.largePhoto
        && lhs.smallPhoto == rhs.smallPhoto
    }
}

@Model final class CachedRecipe {
    @Attribute(.unique) private(set) var id: String
    private(set) var cuisine: String
    private(set) var name: String
    private(set) var photoUrlLargeStr: String?
    private(set) var photoUrlSmallStr: String?
    private(set) var sourceUrlStr: String?
    private(set) var youtubeUrlStr: String?
    @Attribute(.externalStorage) private(set) var smallImgData: Data?
    @Attribute(.externalStorage) private(set) var largeImgData: Data?
    private(set) var index: Int?
    
    init(_ recipe: Recipe) {
        id = recipe.id
        cuisine = recipe.cuisine
        name = recipe.name
        photoUrlLargeStr = recipe.photoUrlLargeStr
        photoUrlSmallStr = recipe.photoUrlSmallStr
        sourceUrlStr = recipe.sourceUrlStr
        youtubeUrlStr = recipe.youtubeUrlStr
        smallImgData = recipe.smallPhoto?.pngData()
        largeImgData = recipe.largePhoto?.pngData()
        index = recipe.index
    }
    
    init(id: String, cuisine: String, name: String, photoUrlLargeStr: String?, photoUrlSmallStr: String?, sourceUrlStr: String?, youtubeUrlStr: String?, smallImgData: Data?, largeImgData: Data?, index: Int?) {
        self.id = id
        self.cuisine = cuisine
        self.name = name
        self.photoUrlLargeStr = photoUrlLargeStr
        self.photoUrlSmallStr = photoUrlSmallStr
        self.sourceUrlStr = sourceUrlStr
        self.youtubeUrlStr = youtubeUrlStr
        self.smallImgData = smallImgData
        self.largeImgData = largeImgData
        self.index = index
    }
}
