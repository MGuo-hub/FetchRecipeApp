//
//  RecipeService.swift
//  FetchRecipeApp
//
//  Created by Tinghe Guo on 12/10/24.
//

import Foundation

class RecipeService {
    private let endpoint: String

    init(endpoint: String = "https://d3jbb8n5wk0qxi.cloudfront.net/recipes.json") {
        self.endpoint = endpoint
    }

    func fetchRecipes() async throws -> [Recipe] {
        let fetched = try await NetworkClient.fetchRecipes(from: endpoint)
        return fetched
    }
}
