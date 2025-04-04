//
//  ViewModel.swift
//  Cookture Prototype
//
//  Created by Myung Joon Kang on 2025-04-04.
//

import SwiftUI

final class ViewModel: ObservableObject {
    @Published var selectedRecipe: Recipe? = nil
}
