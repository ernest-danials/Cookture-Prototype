//
//  RecipeDetailView.swift
//  Cookture Prototype
//
//  Created by Myung Joon Kang on 2025-04-05.
//

import SwiftUI

struct RecipeDetailView: View {
    @EnvironmentObject var viewModel: ViewModel
    
    let recipe: Recipe
    
    init(_ recipe: Recipe) {
        self.recipe = recipe
    }
    
    var body: some View {
        GeometryReader { geo in
            ScrollView {
                LazyVStack {
                    if let imageName = recipe.imageName {
                        Image(imageName)
                            .resizable()
                            .scaledToFill()
                            .frame(width: geo.size.width - 100, height: 410)
                            .clipped()
                            .cornerRadius(20, corners: .allCorners)
                            .padding(.vertical)
                    }
                    
                    Text(recipe.name)
                        .customFont(size: 33, weight: .black)
                    
                    Text(recipe.description)
                        .foregroundStyle(.gray)
                    
                    HStack {
                        HStack(spacing: 5) {
                            Image(systemName: "clock.fill")
                            
                            Text("\(recipe.time) mins")
                        }
                        
                        Text("|").foregroundStyle(.gray)
                        
                        HStack(spacing: 5) {
                            Image(systemName: "flame.fill")
                            
                            Text("\(recipe.calories) kcal")
                        }
                        
                        Text("|").foregroundStyle(.gray)
                        
                        HStack(spacing: 5) {
                            Image(systemName: "fork.knife")
                            
                            Text("\(recipe.servings) servings")
                        }
                        
                        Text("|").foregroundStyle(.gray)
                        
                        HStack(spacing: 5) {
                            Image(systemName: recipe.difficulty.imageName)
                            
                            Text("\(recipe.difficulty.rawValue) difficulty")
                        }
                    }
                    .padding()
                    .background(Material.ultraThin)
                    .cornerRadius(15, corners: .allCorners)
                }
            }
            .navigationTitle(recipe.name)
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    NavigationStack {
        RecipeDetailView(CooktureData.recipeData.first!)
            .environmentObject(ViewModel())
    }
}
