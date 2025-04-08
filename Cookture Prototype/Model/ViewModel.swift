//
//  ViewModel.swift
//  Cookture Prototype
//
//  Created by Myung Joon Kang on 2025-04-04.
//

import SwiftUI

final class ViewModel: ObservableObject {
    @Published var selectedRecipe: Recipe? = nil
    @Published var isShowingCookingView: Bool = false
    @Published var searchText: String = ""
    
    func changeSelectedRecipe(_ recipe: Recipe?) {
        withAnimation(.spring) {
            self.selectedRecipe = recipe
        }
    }
    
    func showCookingView() {
        withAnimation(.spring) {
            self.isShowingCookingView = true
        }
    }
    
    func hideCookingView() {
        withAnimation(.spring) {
            self.isShowingCookingView = false
        }
    }
}
