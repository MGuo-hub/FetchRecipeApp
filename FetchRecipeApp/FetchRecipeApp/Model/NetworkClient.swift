//
//  NetworkClient.swift
//  FetchRecipeApp
//
//  Created by Tinghe Guo on 12/9/24.
//

import Foundation

struct NetworkClient {
    enum NetworkError: Error {
        case invalidURL
        case serverError
        case malformedData
        case emptyData
    }

    // fetch retunrs
    static func fetchRecipes(from urlString: String) async throws -> [Recipe] {
        guard let url = URL(string: urlString) else {
            throw NetworkError.invalidURL
        }

        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResp = response as? HTTPURLResponse, httpResp.statusCode == 200 else {
            throw NetworkError.serverError
        }

        let decoded: RecipesResponse
        do {
            decoded = try JSONDecoder().decode(RecipesResponse.self, from: data)
        } catch {
            // If fails, assume malformed
            throw NetworkError.malformedData
        }
        
        let validRecipes = decoded.recipes.filter { $0.isValid }
        
        // entire dataset malformed.
        if validRecipes.count != decoded.recipes.count {
            throw NetworkError.malformedData
        }
        
        // no recipe, throw emptyData
        if validRecipes.isEmpty {
            throw NetworkError.emptyData
        }

        return validRecipes
    }
}
