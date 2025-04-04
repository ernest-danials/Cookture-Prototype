//
//  ContentView.swift
//  Cookture Prototype
//
//  Created by Myung Joon Kang on 2025-04-03.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var viewModel: ViewModel
    
    var body: some View {
        NavigationSplitView {
            List(CooktureData.recipeData, selection: $viewModel.selectedRecipe) { recipe in
                NavigationLink(recipe.name, value: recipe)
            }
            .navigationTitle("Cookture")
        } detail: {
            if let recipe = viewModel.selectedRecipe {
                Text(recipe.description)
            } else {
                ContentUnavailableView("Choose a recipe", systemImage: "app.dashed")
            }
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(ViewModel())
}
