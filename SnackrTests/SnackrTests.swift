//
//  SnackrTests.swift
//  SnackrTests
//
//  Created by Tyler Maxwell on 4/7/25.
//

import UIKit
import Testing
@testable import Snackr

class SnackrTests {
    
    @Suite
    class RecipesViewModelTests {
        let viewModel: RecipesViewModel
        
        init() {
            let viewModel = RecipesViewModel()
            
            viewModel.recipes = [
                Recipe(id: "1", cuisine: "American", name: "Pancakes", largePhotoURL: nil, smallPhotoURL: nil, sourceURL: nil, youtubeURL: nil),
                Recipe(id: "2", cuisine: "Japanese", name: "Sushi", largePhotoURL: nil, smallPhotoURL: nil, sourceURL: nil, youtubeURL: nil),
                Recipe(id: "3", cuisine: "Indian", name: "Curry", largePhotoURL: nil, smallPhotoURL: nil, sourceURL: nil, youtubeURL: nil)
            ]
            viewModel.searchText = ""
            viewModel.selectedCuisine = "All"
            
            self.viewModel = viewModel
        }
        
        @Test("fetchRecipes() updates recipes on success")
        func testFetchRecipes() async throws {
            let mockRecipes: [Recipe] = [
                Recipe(id: "1", cuisine: "Italian", name: "Pizza", largePhotoURL: nil, smallPhotoURL: nil, sourceURL: nil, youtubeURL: nil),
                Recipe(id: "2", cuisine: "Japanese", name: "Ramen", largePhotoURL: nil, smallPhotoURL: nil, sourceURL: nil, youtubeURL: nil)
            ]
            
            viewModel.fetchRecipesHandler = {
                return mockRecipes
            }
            
            viewModel.fetchRecipes()
            try? await Task.sleep(for: .seconds(0.1))
            
            #expect(viewModel.recipes.count == 2)
            #expect(viewModel.recipes.map { $0.name } == ["Pizza", "Ramen"])
        }
        
        @Test("fetchRecipes() sets errorMessage on failure")
        func testFetchRecipesError() async throws {
            viewModel.fetchRecipesHandler = {
                throw NSError(domain: "NetworkError", code: 1)
            }
            
            viewModel.fetchRecipes()
            try? await Task.sleep(for: .seconds(0.1))
            
            #expect(viewModel.errorMessage != nil)
        }
        
        @Test("filteredRecipes returns all when no search or cuisine filter is applied")
        func testFilteredRecipesAll() async throws {
            let filtered = viewModel.filteredRecipes
            
            #expect(filtered.count == 3)
            #expect(filtered.map { $0.name } == ["Pancakes", "Sushi", "Curry"])
        }
        
        @Test("filteredRecipes filters by search text")
        func testFilteredRecipesSearch() async throws {
            viewModel.searchText = "es"
            
            let filtered = viewModel.filteredRecipes
            
            #expect(filtered.count == 2)
            #expect(filtered.map { $0.name } == ["Pancakes", "Sushi"])
        }
        
        @Test("filteredRecipes filters by selected cuisine")
        func testFilteredRecipesCuisine() async throws {
            viewModel.selectedCuisine = "Indian"
            
            let filtered = viewModel.filteredRecipes
            
            #expect(filtered.count == 1)
            #expect(filtered.map { $0.name } == ["Curry"])
        }
        
        @Test("filteredRecipes filters by both search text and cuisine")
        func testFilteredRecipesSearchAndCuisine() async throws {
            viewModel.searchText = "u"
            viewModel.selectedCuisine = "Japanese"
            
            let filtered = viewModel.filteredRecipes
            
            #expect(filtered.count == 1)
            #expect(filtered.map { $0.name } == ["Sushi"])
        }
        
        @Test("filteredRecipes ignores case in searchText")
        func testFilteredRecipesIgnoreCase() async throws {
            viewModel.searchText = "U"
            
            let filtered = viewModel.filteredRecipes
            
            #expect(filtered.count == 2)
            #expect(filtered.map { $0.name } == ["Sushi", "Curry"])
        }
    }
    
    @Suite
    class ImageCachingServiceTests {
        let imageCachingService = ImageCachingService(fileManager: MockFileManager())
        
        @Test("cacheImage() successfully fetches and caches an image")
        func testCacheImage() async throws {
            let testURL = URL(string: "https://example.com/test-image.png")!
            let key = testURL.pathComponents.suffix(2).joined(separator: "_")
            
            let cachedImage = await imageCachingService.cacheImage(with: key, url: testURL)
            
            #expect(cachedImage != nil)
        }
        
        @Test("getCachedImage() successfully gets cached image")
        func testGetCachedImage() async throws {
            let testURL = URL(string: "https://example.com/test-image.png")!
            let key = testURL.pathComponents.suffix(2).joined(separator: "_")
            
            let _ = await imageCachingService.cacheImage(with: key, url: testURL)
            
            let cachedImage = await imageCachingService.getCachedImage(with: key)
            
            #expect(cachedImage != nil)
        }
        
        @Test("getCachedImage() returns nil if image is not found")
        func testGetCachedImageNotFound() async throws {
            let testURL = URL(string: "https://example.com/fake-image.png")!
            let key = testURL.pathComponents.suffix(2).joined(separator: "_")
            
            #expect(await imageCachingService.getCachedImage(with: key) == nil)
        }
    }
    
    @Suite
    class NetworkServiceTests {
        @Test("fetchRecipes() successfully fetches a list of recipes")
        func testFetchRecipes() async throws {
            let networkService = NetworkService(urlSession: MockURLSession(url: "https://d3jbb8n5wk0qxi.cloudfront.net/recipes.json"))
            
            let recipes = try await networkService.fetchRecipes()
            
            #expect(recipes.count > 0)
        }
        
        @Test("fetchRecipes() parses an empty list of recipes")
        func testFetchRecipesEmpty() async throws {
            let networkService = NetworkService(urlSession: MockURLSession(url: "https://d3jbb8n5wk0qxi.cloudfront.net/recipes-empty.json"))
            
            let recipes = try await networkService.fetchRecipes()
            
            #expect(recipes.isEmpty)
        }
        
        @Test("fetchRecipes() throws catchable error when JSON is malformed")
        func testFetchRecipesMalformedJSON() async throws {
            let networkService = NetworkService(urlSession: MockURLSession(url: "https://d3jbb8n5wk0qxi.cloudfront.net/recipes-malformed.json"))
            
            var errorMessage: String?
            do {
                let _ = try await networkService.fetchRecipes()
            } catch {
                errorMessage = error.localizedDescription
            }
            
            #expect(errorMessage != nil)
        }
    }
}

