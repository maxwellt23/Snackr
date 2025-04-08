//
//  NetworkService.swift
//  Snackr
//
//  Created by Tyler Maxwell on 4/7/25.
//

import Foundation

class NetworkService {
    private let urlSession: URLSessionProtocol
    
    init(urlSession: URLSessionProtocol = DefaultURLSession(url: "https://d3jbb8n5wk0qxi.cloudfront.net/recipes.json")) {
        self.urlSession = urlSession
    }
    
    func fetchRecipes() async throws -> [Recipe] {
        guard let url = URL(string: urlSession.url) else {
            throw NSError(domain: "Invalid URL", code: 0)
        }
        
        let data = try urlSession.contentsOf(url: url)
        let response = try JSONDecoder().decode(RecipesResponse.self, from: data)
        
        return response.recipes
    }
}
