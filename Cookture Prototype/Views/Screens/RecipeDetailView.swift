//
//  RecipeDetailView.swift
//  Cookture Prototype
//
//  Created by Myung Joon Kang on 2025-04-05.
//

import SwiftUI
import GlowGetter

struct RecipeDetailView: View {
    @EnvironmentObject var viewModel: ViewModel
    
    @Environment(\.colorScheme) var colorScheme
    
    let recipe: Recipe
    
    init(_ recipe: Recipe) {
        self.recipe = recipe
    }
    
    var body: some View {
        ScrollViewReader { proxy in
            ScrollView {
                LazyVStack {
                    if let imageName = recipe.imageName {
                        Image(imageName)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 700, height: 410)
                            .clipped()
                            .cornerRadius(20, corners: .allCorners)
                            .padding(.vertical)
                            .id("top")
                    }
                    
                    Text(recipe.name)
                        .customFont(size: 33, weight: .black)
                    
                    Text(recipe.description)
                        .foregroundStyle(.gray)
                    
                    info
                    
                    Divider()
                        .frame(width: 700)
                        .padding()
                    
                    VStack {
                        Text("Ingredients")
                            .customFont(size: 20, weight: .semibold)
                            .alignView(to: .leading)
                        
                        VStack(alignment: .leading, spacing: 8) {
                            ForEach(recipe.ingredients) { ingredient in
                                HStack(spacing: 4) {
                                    Text(ingredient.amount.capitalisedFirst)
                                        .customFont(size: 20)
                                    
                                    Text(ingredient.name)
                                        .customFont(size: 20, weight: .bold)
                                        .foregroundStyle(.seaBlue)
                                }
                            }
                        }
                        .alignView(to: .leading)
                        .padding()
                        .background(Material.ultraThin)
                        .cornerRadius(20, corners: .allCorners)
                    }
                    .frame(width: 700)
                }.safeAreaPadding(.bottom, 20)
            }
            .onChange(of: self.viewModel.selectedRecipe) { oldValue, newValue in
                if oldValue?.id != newValue?.id {
                    withAnimation(.spring) { proxy.scrollTo("top") }
                }
            }
        }
        .navigationTitle(recipe.name)
        .navigationBarTitleDisplayMode(.inline)
        .safeAreaInset(edge: .bottom) {
            Button {
                self.viewModel.showCookingView()
            } label: {
                HStack(spacing: 14) {
                    Image(systemName: "play.fill")
                        .customFont(size: 30)
                        .foregroundStyle(.accent)
                    
                    Text("Start Cooking")
                        .customFont(size: 25, weight: .bold)
                        .foregroundStyle(.accent)
                }
                .padding(25)
                .background {
                    Capsule()
                        .fill(Color.white)
                        .shadow(color: .black.opacity(0.3), radius: 25)
                        .glow(1.0, Capsule())
                }
                .padding()
            }
            .scaleButtonStyle()
            .alignView(to: .trailing)
        }
    }
    
    var info: some View {
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
        .cornerRadius(17, corners: .allCorners)
    }
}

#Preview {
    NavigationStack {
        RecipeDetailView(CooktureData.recipeData.first!)
            .environmentObject(ViewModel())
    }
}
