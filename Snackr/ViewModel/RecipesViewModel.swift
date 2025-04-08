//
//  RecipesViewModel.swift
//  Snackr
//
//  Created by Tyler Maxwell on 4/7/25.
//

import UIKit

class RecipesViewModel: ObservableObject {
    @Published var recipes: [Recipe] = []
    @Published var searchText: String = ""
    @Published var selectedCuisine: String = "All"
    @Published var errorMessage: String?
    
    // For testing purposes only
    var fetchRecipesHandler: () async throws -> [Recipe] = NetworkService().fetchRecipes
    
    var filteredRecipes: [Recipe] {
        recipes
            .filter {
                !selectedCuisine.isEmpty && selectedCuisine != "All" ? $0.cuisine == selectedCuisine : true
            }
            .filter(with: searchText)
    }
    
    func fetchRecipes() {
        self.errorMessage = nil
        
        Task {
            do {
                let recipes = try await fetchRecipesHandler()
                
                DispatchQueue.main.async {
                    self.recipes = recipes
                }
            } catch {
                DispatchQueue.main.async {
                    self.errorMessage = "Unable to load recipes. Please try again later."
                }
            }
        }
    }
}
