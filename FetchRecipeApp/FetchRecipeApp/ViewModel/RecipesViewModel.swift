//
//  RecipesViewModel.swift
//  FetchRecipeApp
//
//  Created by Tinghe Guo on 12/9/24.
//

import SwiftUI

@MainActor
class RecipesViewModel: ObservableObject {
    @Published var recipes: [Recipe] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?

    private let recipeService: RecipeService
    let imageCache = ImageCacheManager()

    init(recipeService: RecipeService = RecipeService()) {
        self.recipeService = recipeService
    }

    func loadRecipes() async {
        isLoading = true
        errorMessage = nil

        do {
            let fetched = try await recipeService.fetchRecipes()
            recipes = fetched
            if recipes.isEmpty {
                errorMessage = "No recipes available."
            }
        } catch {
            handle(error: error)
        }

        isLoading = false
    }

    func refresh() async {
        await loadRecipes()
    }

    func loadImage(for recipe: Recipe) async -> Image? {
        guard let urlString = recipe.photo_url_small ?? recipe.photo_url_large else {
            return nil
        }

        do {
            let uiImage = try await imageCache.loadImage(from: urlString)
            return Image(uiImage: uiImage)
        } catch {
            print("Failed to load image for \(recipe.name): \(error)")
            return nil
        }
    }

    func handle(error: Error) {
        let fetchError: FetchError

        if let netErr = error as? NetworkClient.NetworkError {
            switch netErr {
            case .invalidURL:
                fetchError = .invalidURL
            case .serverError:
                fetchError = .serverError
            case .malformedData:
                fetchError = .malformedData
            case .emptyData:
                fetchError = .emptyData
            }
        } else {
            fetchError = .unknown(error)
        }

        errorMessage = fetchError.userFriendlyMessage
    }

    
    func loadImageFromURLString(_ urlString: String) async -> Image? {
        do {
            let uiImage = try await imageCache.loadImage(from: urlString)
            return Image(uiImage: uiImage)
        } catch {
            print("Failed to load large image: \(error)")
            return nil
        }
    }
    
}
