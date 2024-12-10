//
//  Recipt.swift
//  FetchRecipeApp
//
//  Created by Tinghe Guo on 12/9/24.
//

import Foundation

struct RecipesResponse: Decodable {
    let recipes: [Recipe]
}

struct Recipe: Decodable {
    let cuisine: String
    let name: String
    let photo_url_large: String?
    let photo_url_small: String?
    let uuid: String
    let source_url: String?
    let youtube_url: String?

    // Validation purpose
    var isValid: Bool {
        // check required field
        return !cuisine.isEmpty && !name.isEmpty && !uuid.isEmpty
    }
}
