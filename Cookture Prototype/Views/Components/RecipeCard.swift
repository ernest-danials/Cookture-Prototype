//
//  RecipeCard.swift
//  Cookture Prototype
//
//  Created by Myung Joon Kang on 2025-04-05.
//

import SwiftUI

struct RecipeCard: View {
    let recipe: Recipe
    let maxWidth: CGFloat
    let maxImageHeight: CGFloat
    
    init(_ recipe: Recipe, maxWidth: CGFloat = 300, maxImageHeight: CGFloat = 200) {
        self.recipe = recipe
        self.maxWidth = maxWidth
        self.maxImageHeight = maxImageHeight
    }
    
    var body: some View {
        VStack(spacing: 0) {
            if let imageName = recipe.imageName {
                Image(imageName)
                    .resizable()
                    .scaledToFill()
                    .frame(maxWidth: maxWidth, maxHeight: maxImageHeight)
                    .clipped()
                    .cornerRadius(20, corners: [.topLeft, .topRight])
            } else {
                Image(systemName: "photo.badge.exclamationmark")
            }
            
            VStack(alignment: .leading, spacing: 2) {
                Text(recipe.name)
                    .customFont(size: 18, weight: .bold)
                
                HStack(spacing: 4) {
                    Text(recipe.category)
                    
                    Text("⋅")
                    
                    Text("\(recipe.calories) kcal")
                }
                .customFont(size: 15, weight: .medium)
                .foregroundStyle(.gray)
            }
            .alignView(to: .leading)
            .padding()
            .background(Material.ultraThin)
            .cornerRadius(20, corners: [.bottomLeft, .bottomRight])
        }
        .frame(maxWidth: maxWidth)
        .padding(.horizontal)
    }
}

#Preview {
    RecipeCard(CooktureData.recipeData.first!, maxImageHeight: 200)
}
