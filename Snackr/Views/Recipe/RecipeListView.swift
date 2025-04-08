//
//  RecipeListView.swift
//  Snackr
//
//  Created by Tyler Maxwell on 4/7/25.
//

import SwiftUI

struct RecipeListView: View {
    @StateObject private var viewModel: RecipesViewModel = .init()
    @FocusState private var isSearching: Bool
    
    // For Hero Animation
    @State private var selectedRecipe: Recipe?
    
    init() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        UINavigationBar.appearance().compactAppearance = appearance
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color("Background")
                    .ignoresSafeArea()
                
                SnackrRefreshableView {
                    LazyVStack(spacing: 12) {
                        if viewModel.filteredRecipes.isEmpty {
                            VStack(alignment: .center, spacing: 8) {
                                Image("LogoOnly")
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 100, height: 100)
                                
                                Text("No recipes found. Change your filters and try again.")
                                    .font(.headline)
                                    .foregroundStyle(Color("SText"))
                                    .multilineTextAlignment(.center)
                            }
                        } else {
                            ForEach(viewModel.filteredRecipes) { recipe in
                                NavigationLink(destination: RecipeDetailView(recipe: recipe)) {
                                    RecipeListItem(recipe: recipe)
                                }
                            }
                        }
                    }
                    .safeAreaPadding(15)
                    .safeAreaInset(edge: .top, spacing: 0) {
                        SnackrSearchBar(
                            title: "Hungry? Let's fix that.",
                            placeholder: "Search Recipes",
                            searchText: $viewModel.searchText,
                            filterOptions: Set(viewModel.recipes.map { $0.cuisine }).union(["All"]),
                            selection: $viewModel.selectedCuisine,
                            isSearching: _isSearching
                        )
                    }
                    .animation(.snappy(duration: 0.3, extraBounce: 0), value: isSearching)
                } onRefresh: {
                    viewModel.fetchRecipes()
                }
                .scrollTargetBehavior(CustomScrollTargetBehavior())
            }
            .toastView(message: $viewModel.errorMessage)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Image("Logo")
                        .resizable()
                        .scaledToFit()
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .onAppear {
                viewModel.fetchRecipes()
            }
        }
    }
}
