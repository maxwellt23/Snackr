//
//  RecipeDetailView.swift
//  Snackr
//
//  Created by Tyler Maxwell on 4/8/25.
//

import SwiftUI

struct RecipeDetailView: View {
    let recipe: Recipe
    
    @Environment(\.dismiss) private var dismiss
    @Environment(\.openURL) var openURL
    
    var body: some View {
        ZStack {
            Color("Background")
                .ignoresSafeArea()
            
            VStack {
                SnackrCachedImage(url: URL(string: recipe.largePhotoURL ?? "")) { image in
                    image
                        .resizable()
                        .scaledToFill()
                        .frame(maxWidth: .infinity)
                        .frame(height: 300)
                } placeholder: {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color("Neutral").opacity(0.25))
                        .frame(maxWidth: .infinity)
                        .frame(height: 300)
                }
                .ignoresSafeArea()
                
                VStack(alignment: .leading) {
                    Text(recipe.name)
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundStyle(Color("PText"))
                        .padding(.top)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Text(recipe.cuisine)
                        .font(.title3)
                        .foregroundStyle(Color("SText"))
                    
                    Divider()
                        .background(Color("Neutral"))
                        .padding(.vertical)
                    
                    if let sourceURL = recipe.sourceURL, let url = URL(string: sourceURL) {
                        Button(action: {
                            openURL(url)
                        }) {
                            Text("View Recipe")
                                .font(.headline)
                                .foregroundStyle(.white)
                                .padding(.vertical, 8)
                                .padding(.horizontal, 15)
                                .background(Color("Accent"), in: .capsule)
                        }
                        .frame(maxWidth: .infinity, alignment: .trailing)
                        .padding(.bottom)
                    }
                    
                    if let youtubeURL = recipe.youtubeURL {
                        let videoID = String(youtubeURL.split(separator: "?v=").last ?? "")
                                             
                        SnackrYoutubeView(videoId: videoID)
                            .clipShape(.rect(cornerRadius: 8))
                    }
                }
                .padding(.horizontal, 15)
                
                Spacer()
            }
        }
        .overlay(alignment: .topLeading) {
            Button(action: {
                dismiss()
            }) {
                Image(systemName: "chevron.left")
                    .font(.title3)
                    .foregroundStyle(.white)
                    .padding()
                    .background(Color("Accent"), in: .circle)
                    .padding()
            }
        }
        .navigationBarBackButtonHidden()
    }
}
