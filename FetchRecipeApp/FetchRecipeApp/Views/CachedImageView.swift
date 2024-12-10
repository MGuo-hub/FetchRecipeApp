//
//  CachedImageView.swift
//  FetchRecipeApp
//
//  Created by Tinghe Guo on 12/10/24.
//

import SwiftUI

struct CachedImageView: View {
let recipe: Recipe
@ObservedObject var viewModel: RecipesViewModel
@State private var image: Image?
@State private var isLoading: Bool = false

var body: some View {
    ZStack {
        if let image = image {
            image.resizable().scaledToFill()
        } else if isLoading {
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle())
        } else {
            
            Color.gray
        }
    }
    .onAppear {
        Task {
            if image == nil {
                isLoading = true
                image = await viewModel.loadImage(for: recipe)
                isLoading = false
            }
        }
    }
}
}
