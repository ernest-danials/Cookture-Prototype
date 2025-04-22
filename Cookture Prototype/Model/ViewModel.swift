//
//  ViewModel.swift
//  Cookture Prototype
//
//  Created by Myung Joon Kang on 2025-04-04.
//

import SwiftUI

final class ViewModel: ObservableObject {
    // MARK: - AppStorage Properties
    @AppStorage("probabilityThreshold", store: .standard) var probabilityThreshold: Double = 0.8
    @AppStorage("swipeUpScore", store: .standard) var swipeUpScore: Int = 0
    @AppStorage("swipeDownScore", store: .standard) var swipeDownScore: Int = 0
    @AppStorage("openFistScore", store: .standard) var openFistScore: Int = 0
    @AppStorage("closeFistScore", store: .standard) var closeFistScore: Int = 0
    
    // MARK: - Published Properties
    @Published var selectedRecipe: Recipe? = nil
    @Published var isShowingCookingView: Bool = false
    @Published var searchText: String = ""
    @Published var isShowingSettingsView: Bool = false
    
    // MARK: - Functions
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
    
    func showSettingsView() {
        withAnimation(.spring) {
            self.isShowingSettingsView = true
        }
    }
    
    func hideSettingsView() {
        withAnimation(.spring) {
            self.isShowingSettingsView = false
        }
    }
    
    func resetProbabilityThresholdToDefault() {
        withAnimation(.spring) {
            self.probabilityThreshold = 0.8
        }
    }
    
    func deleteClassificationHistory() {
        withAnimation(.spring) {
            self.swipeUpScore = 0
            self.swipeDownScore = 0
            self.openFistScore = 0
            self.closeFistScore = 0
        }
    }
}
