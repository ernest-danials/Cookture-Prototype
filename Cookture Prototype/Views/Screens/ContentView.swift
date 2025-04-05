//
//  ContentView.swift
//  Cookture Prototype
//
//  Created by Myung Joon Kang on 2025-04-03.
//

import SwiftUI
import RenderMeThis

struct ContentView: View {
    @EnvironmentObject var viewModel: ViewModel
    
    var body: some View {
        NavigationSplitView {
            ScrollView {
                LazyVStack(spacing: 20) {
                    ForEach(CooktureData.recipeData) { recipe in
                        Button {
                            self.viewModel.changeSelectedRecipe(recipe)
                        } label: {
                            RecipeCard(recipe)
                        }
                        .scaleButtonStyle()
                    }
                }
            }
            .prioritiseScaleButtonStyle()
            .navigationTitle("Cookture")
        } detail: {
            if let recipe = viewModel.selectedRecipe {
                RecipeDetailView(recipe)
            } else {
                ContentUnavailableView("Choose a recipe", systemImage: "carrot.fill")
            }
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(ViewModel())
}
