//
//  RecipeListItem.swift
//  Snackr
//
//  Created by Tyler Maxwell on 4/7/25.
//

import SwiftUI

struct RecipeListItem: View {
    let recipe: Recipe
    
    var body: some View {
        HStack(spacing: 16) {
            SnackrCachedImage(url: URL(string: recipe.smallPhotoURL ?? "")) { image in
                image
                    .resizable()
                    .scaledToFill()
                    .frame(width: 50, height: 50)
                    .clipShape(.rect(cornerRadius: 8))
            } placeholder: {
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color("Neutral").opacity(0.25))
                    .frame(width: 50, height: 50)
                    .clipShape(.rect(cornerRadius: 8))
            }
            
            VStack(alignment: .leading) {
                Text(recipe.name)
                    .font(.headline)
                    .foregroundStyle(Color("PText"))
                
                Text(recipe.cuisine)
                    .font(.subheadline)
                    .foregroundStyle(Color("SText"))
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(8)
        .frame(height: 70)
        .background {
            RoundedRectangle(cornerRadius: 8)
                .fill(Color("Surface"))
                .shadow(color: Color("Shadow").opacity(0.4), radius: 5, x: 0, y: 5)
        }
    }
}
