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
    let ingredients: [String]
    let steps: [Step]
    let time: Int
    let servings: Int
    let category: String
    let difficulty: Difficulty
    let calories: Int
}

struct Step: Identifiable, Hashable {
    let id = UUID()
    let order: Int
    let instruction: String
    let imageName: String?
    let duration: Int?
    let isTimerRequired: Bool
}

enum Difficulty: String, CaseIterable {
    case easy = "Easy"
    case medium = "Medium"
    case hard = "Hard"
    
    var imageName: String {
        switch self {
        case .easy:
            return "leaf"
        case .medium:
            return "flame"
        case .hard:
            return "bolt"
        }
    }
}
