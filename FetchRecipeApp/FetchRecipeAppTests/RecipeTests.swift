//
//  RecipeTests.swift
//  FetchRecipeAppTests
//
//  Created by Tinghe Guo on 12/10/24.
//
import XCTest
@testable import FetchRecipeApp

final class RecipeTests: XCTestCase {
    func testValidRecipe() {
        let recipe = Recipe(
            cuisine: "Italian",
            name: "Pasta",
            photo_url_large: nil,
            photo_url_small: nil,
            uuid: "some-uuid",
            source_url: nil,
            youtube_url: nil
        )
        XCTAssertTrue(recipe.isValid)
    }

    func testInvalidRecipeMissingName() {
        let recipe = Recipe(
            cuisine: "Italian",
            name: "",
            photo_url_large: nil,
            photo_url_small: nil,
            uuid: "some-uuid",
            source_url: nil,
            youtube_url: nil
        )
        XCTAssertFalse(recipe.isValid)
    }
}
