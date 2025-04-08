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
                    let shownRecipes = CooktureData.recipeData.filter { $0.name.hasPrefix(self.viewModel.searchText) }
                    
                    if !shownRecipes.isEmpty {
                        ForEach(shownRecipes) { recipe in
                            Button {
                                self.viewModel.changeSelectedRecipe(recipe)
                            } label: {
                                RecipeCard(recipe)
                            }.scaleButtonStyle()
                        }
                    } else {
                        ContentUnavailableView("No Results", systemImage: "magnifyingglass", description: Text("There are no recipes matching your search for \"\(self.viewModel.searchText).\" Check your spelling or try a different search"))
                    }
                }.padding(.top, 10)
            }
            .prioritiseScaleButtonStyle()
            .navigationTitle("Cookture")
            .searchable(text: $viewModel.searchText, placement: .sidebar, prompt: Text("Search for a recipe"))
        } detail: {
            if let recipe = viewModel.selectedRecipe {
                RecipeDetailView(recipe)
            } else {
                ContentUnavailableView("Choose a recipe", systemImage: "carrot.fill")
            }
        }
        .fullScreenCover(isPresented: $viewModel.isShowingCookingView) {
            VStack {
                Text("CookingView for \(self.viewModel.selectedRecipe?.name ?? "nil")")
                
                Button("Dismiss") { self.viewModel.hideCookingView() }
                
                Divider().padding()
                
                ForEach(viewModel.selectedRecipe?.steps ?? CooktureData.recipeData.first!.steps) { step in
                    Text(step.instruction)
                }
            }
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(ViewModel())
}
