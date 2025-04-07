//
//  Recipe.swift
//  Cookture Prototype
//
//  Created by Myung Joon Kang on 2025-04-04.
//

import Foundation

struct Recipe: Identifiable, Hashable {
    let id = UUID()
    let name: String
    let description: String
    let imageName: String?
    let ingredients: [Ingredient]
    let steps: [Step]
    let time: Int
    let servings: Int
    let category: String
    let difficulty: Difficulty
    let calories: Int
}

struct Ingredient: Identifiable, Hashable {
    let id = UUID()
    let amount: String
    let name: String
}

struct Step: Identifiable, Hashable {
    let id = UUID()
    let order: Int
    let instruction: String
    let imageName: String?
    let timerDuration: Int?
}

enum Difficulty: String, CaseIterable {
    case easy = "Easy"
    case medium = "Medium"
    case hard = "Hard"
    
    var imageName: String {
        switch self {
        case .easy:
            return "leaf.fill"
        case .medium:
            return "flag.fill"
        case .hard:
            return "bolt.fill"
        }
    }
}
