//
//  Recipe.swift
//  Snackr
//
//  Created by Tyler Maxwell on 4/7/25.
//

import Foundation

struct Recipe: Identifiable, Hashable, Codable, Searchable {
    let id: String
    let cuisine: String
    let name: String
    let largePhotoURL: String?
    let smallPhotoURL: String?
    let sourceURL: String?
    let youtubeURL: String?
    
    enum CodingKeys: String, CodingKey {
        case id = "uuid"
        case cuisine
        case name
        case largePhotoURL = "photo_url_large"
        case smallPhotoURL = "photo_url_small"
        case sourceURL = "source_url"
        case youtubeURL = "youtube_url"
    }
    
    func searchableStringProperties() -> [String] {
        [cuisine, name]
    }
}

struct RecipesResponse: Codable {
    let recipes: [Recipe]
}
