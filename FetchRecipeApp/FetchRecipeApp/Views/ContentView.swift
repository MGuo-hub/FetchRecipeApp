//
//  ContentView.swift
//  FetchRecipeApp
//
//  Created by Tinghe Guo on 12/9/24.
//
import SwiftUI

struct ContentView: View {
    @StateObject var viewModel = RecipesViewModel()

    private let categories = ["Italian", "American", "British", "Canadian", "French", "Other"]
    private let knownCuisines = ["Italian", "American", "British", "Canadian", "French"]

    @State private var selectedCategory: String? = nil
    @State private var searchQuery: String = ""
    @State private var selectedRecipe: Recipe? = nil

    private var filteredRecipes: [Recipe] {
        let base = viewModel.recipes.filter { recipe in
            // Filter by category
            if let cat = selectedCategory {
                if cat == "Other" {
                    return !knownCuisines.contains(recipe.cuisine)
                } else {
                    return recipe.cuisine == cat
                }
            } else {
                return true // No category selected, show all
            }
        }

        // search query
        if searchQuery.isEmpty {
            return base
        } else {
            return base.filter { $0.name.localizedCaseInsensitiveContains(searchQuery) }
        }
    }

    var body: some View {
        ZStack {
            Color.lightGreen.ignoresSafeArea()

            VStack(alignment: .leading, spacing: 16) {
                Text("Hello, Chef! 👋")
                    .font(.custom("Fredoka-SemiBold", size: 27))
                    .foregroundColor(.black)
                    .padding(.top, 10)
                    .padding(.horizontal, 12)
                    .padding(5)

                // Search Bar
                HStack {
                    Image(systemName: "magnifyingglass").foregroundColor(.black)
                    TextField("What do you like to make today?", text: $searchQuery)
                        .font(.custom("Fredoka-SemiBold", size: 16))
                        .foregroundColor(.black)
                    Spacer()
                }
                .padding()
                .background(Color.lightGray)
                .cornerRadius(12)
                .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.black, lineWidth: 1))
                .shadow(radius: 1)
                .padding(.horizontal, 12)

                Text("Country of Flavors")
                    .font(.custom("Fredoka-Medium", size: 20))
                    .foregroundColor(.black)
                    .padding(.horizontal, 12)
                    .padding(.leading, 12)
                    .padding(.top, 5)

                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        ForEach(categories, id: \.self) { category in
                            Button {
                                if selectedCategory == category {
                                    selectedCategory = nil
                                } else {
                                    selectedCategory = category
                                }
                            } label: {
                                VStack(spacing: 4) {
                                    Text(flagForCategory(category))
                                        .font(.system(size: 28))
                                        .frame(width: 50, height: 40)

                                    Text(category)
                                        .font(.custom("Fredoka-Medium", size: 12))
                                        .foregroundColor(.black)
                                }
                                .padding(.vertical, 6)
                                .padding(.horizontal, 10)
                                .background(selectedCategory == category ? Color.fetchOrange : Color.white)
                                .cornerRadius(8)
                                .shadow(radius: 1)
                            }
                        }
                    }
                    .padding(.vertical, 2)
                    .padding(.horizontal, 10)
                }

                Text("Recipes")
                    .font(.custom("Fredoka-Medium", size: 20))
                    .foregroundColor(.black)
                    .padding(.horizontal, 12)
                    .padding(.leading, 12)

                
                ScrollView {
                    if viewModel.isLoading {
                        ProgressView("Loading...").padding()
                    } else if let error = viewModel.errorMessage {
                        Text(error).foregroundColor(.gray).padding()
                    } else if filteredRecipes.isEmpty {
                        Text("No recipes available.").padding()
                    } else {
                        let columns = [GridItem(.flexible()), GridItem(.flexible())]
                        LazyVGrid(columns: columns, spacing: 10) {
                            ForEach(filteredRecipes, id: \.uuid) { recipe in
                                VStack {
                                    CachedImageView(recipe: recipe, viewModel: viewModel)
                                        .frame(width: 120, height: 120)
                                        .cornerRadius(12)

                                    Text(recipe.name)
                                        .font(.custom("Fredoka-Medium", size: 16))
                                        .foregroundColor(.black)
                                        .multilineTextAlignment(.center)
                                        .lineLimit(3)

                                    Text(recipe.cuisine)
                                        .font(.custom("Fredoka-Regular", size: 14))
                                        .foregroundColor(.gray)
                                        .padding(.top, 1)
                                }
                                .frame(width: 130)
                                .padding()
                                .background(Color.lightGray)
                                .cornerRadius(16)
                                .shadow(radius: 1)
                                .onTapGesture {
                                    selectedRecipe = recipe
                                }
                            }
                        }
                        .padding([.top, .horizontal], 12)
                        .padding(.bottom, 40)
                    }
                }
                .refreshable { // Pull-to-refresh
                    await viewModel.refresh()
                }
            }

            // Popup overlay
            if let recipe = selectedRecipe {
                ZStack {
                    Color.black.opacity(0.4)
                        .ignoresSafeArea()
                        .onTapGesture {
                            selectedRecipe = nil
                        }

                    RecipeCardView(recipe: recipe, viewModel: viewModel) {
                        selectedRecipe = nil
                    }
                    .frame(width: UIScreen.main.bounds.width * 0.8,
                           height: UIScreen.main.bounds.height * 0.55)
                    .background(Color.white)
                    .cornerRadius(20)
                    .shadow(radius: 10)
                }
                .transition(.opacity)
            }
        }
        .onAppear {
            Task { await viewModel.loadRecipes() }
        }
    }

    private func flagForCategory(_ category: String) -> String {
        switch category {
        case "American": return "🇺🇸"
        case "British": return "🇬🇧"
        case "Canadian": return "🇨🇦"
        case "French": return "🇫🇷"
        case "Italian": return "🇮🇹"
        default: return "🌍"
        }
    }
}

#Preview {
    ContentView()
}
