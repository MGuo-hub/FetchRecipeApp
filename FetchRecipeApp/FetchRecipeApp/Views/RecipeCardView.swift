//
//  RecipeCardView.swift
//  FetchRecipeApp
//
//  Created by Tinghe Guo on 12/9/24.
//
import SwiftUI
struct RecipeCardView: View {
    let recipe: Recipe
    @ObservedObject var viewModel: RecipesViewModel
    let onClose: () -> Void
    
    @Environment(\.openURL) var openURL
    
    @State private var image: Image?
    
    var body: some View {
        VStack(spacing: 16) {
        
            
            HStack {
                Spacer()
                Button(action: onClose) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.gray)
                        .font(.system(size: 27))
                }
                .padding(.trailing, 16)
                
            }
            .padding(.top, -20)
            
            
            VStack(spacing: 10) {
                Text(recipe.name)
                    .font(.custom("Fredoka-SemiBold", size: 22))
                    .foregroundColor(.black)
                    .multilineTextAlignment(.center)
                
                Text(recipe.cuisine + " Cuisine")
                    .font(.custom("Fredoka-Regular", size: 16))
                    .foregroundColor(.gray)
            }
            .padding(.top, -20)
            .padding(.horizontal, 10)

          
            
            if let image = image {
                image
                    .resizable()
                    .scaledToFit()
                    .frame(height: 250)
                    .clipped()
                    .cornerRadius(10)
                    .padding(.horizontal, 5)
            } else {
                Color.gray
                    .frame(height: 250)
                    .cornerRadius(10)
                    .padding(.horizontal, 5)
                    .task {
                        await loadImage()
                    }
            }
            
           
            
            HStack(spacing: 20) {
                if let sourceURL = recipe.source_url, let url = URL(string: sourceURL) {
                    Button(action: {
                        openURL(url)
                    }) {
                        Label("Read Recipe", systemImage: "book.fill")
                            .font(.custom("Fredoka-SemiBold", size: 15))
                            .padding(8)
                            .background(Color.fetchOrange)
                            .foregroundColor(.black)
                            .cornerRadius(8)
                    }
                }
                
                if let youtubeURL = recipe.youtube_url, let ytURL = URL(string: youtubeURL) {
                    Button(action: {
                        openURL(ytURL)
                    }) {
                        Label("Watch Video", systemImage: "play.rectangle.fill")
                            .font(.custom("Fredoka-SemiBold", size: 15))
                            .padding(8)
                            .background(Color.fetchOrange)
                            .foregroundColor(.black)
                            .cornerRadius(8)
                    }
                }
            }
            .padding(.top, 10)
            .padding(.bottom, 10)
        }
    }
    
    private func loadImage() async {
        guard let urlString = recipe.photo_url_large ?? recipe.photo_url_small else { return }
        image = await viewModel.loadImageFromURLString(urlString)
    }
}


