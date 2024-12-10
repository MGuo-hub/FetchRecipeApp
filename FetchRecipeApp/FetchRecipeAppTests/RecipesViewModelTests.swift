//
//  RecipesViewModelTests.swift
//  FetchRecipeAppTests
//
//  Created by Tinghe Guo on 12/10/24.
//
import XCTest
@testable import FetchRecipeApp
import SwiftUI

final class MockRecipeService: RecipeService {
    var recipesToReturn: [Recipe] = []
    var shouldThrow: Error?

    override func fetchRecipes() async throws -> [Recipe] {
        if let error = shouldThrow {
            throw error
        }
        return recipesToReturn
    }
}

