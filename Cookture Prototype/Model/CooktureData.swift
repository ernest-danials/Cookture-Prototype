//
//  MockData.swift
//  Cookture Prototype
//
//  Created by Myung Joon Kang on 2025-04-04.
//

import Foundation

struct CooktureData {
    static let recipeData: [Recipe] = [
        Recipe(
            name: "Spaghetti Bolognese",
            description: "A classic Italian pasta with rich meat sauce.",
            imageName: "spaghetti.bolognese",
            ingredients: ["Spaghetti", "Ground beef", "Tomato sauce", "Onion", "Garlic"],
            steps: [
                Step(order: 1, instruction: "Boil spaghetti until al dente.", imageName: nil, timerDuration: 10),
                Step(order: 2, instruction: "Cook ground beef until browned.", imageName: nil, timerDuration: 8),
                Step(order: 3, instruction: "Add tomato sauce, onion, and garlic. Simmer.", imageName: nil, timerDuration: 15)
            ],
            time: 35,
            servings: 4,
            category: "Main",
            difficulty: Difficulty.medium,
            calories: 620
        ),
        
        Recipe(
            name: "Avocado Toast",
            description: "Quick and healthy breakfast with mashed avocado.",
            imageName: "avocado.toast",
            ingredients: ["Bread", "Avocado", "Salt", "Pepper", "Lemon"],
            steps: [
                Step(order: 1, instruction: "Toast the bread.", imageName: nil, timerDuration: 3),
                Step(order: 2, instruction: "Mash avocado with salt, pepper, and lemon juice.", imageName: nil, timerDuration: 2),
                Step(order: 3, instruction: "Spread mixture on toast and serve.", imageName: nil, timerDuration: 1)
            ],
            time: 6,
            servings: 1,
            category: "Breakfast",
            difficulty: Difficulty.easy,
            calories: 250
        ),
        
        Recipe(
            name: "Chicken Curry",
            description: "Spicy and flavourful Indian-style chicken curry.",
            imageName: "chicken.curry",
            ingredients: ["Chicken", "Curry powder", "Onion", "Tomato", "Coconut milk"],
            steps: [
                Step(order: 1, instruction: "Sauté onions until golden.", imageName: nil, timerDuration: 5),
                Step(order: 2, instruction: "Add chicken and cook thoroughly.", imageName: nil, timerDuration: 10),
                Step(order: 3, instruction: "Stir in spices, tomato, and coconut milk. Simmer.", imageName: nil, timerDuration: 20)
            ],
            time: 40,
            servings: 4,
            category: "Main",
            difficulty: Difficulty.hard,
            calories: 700
        ),
        
        Recipe(
            name: "Pancakes",
            description: "Fluffy homemade pancakes perfect for breakfast.",
            imageName: "pancakes",
            ingredients: ["Flour", "Milk", "Egg", "Baking powder", "Sugar"],
            steps: [
                Step(order: 1, instruction: "Mix dry and wet ingredients into a batter.", imageName: nil, timerDuration: 5),
                Step(order: 2, instruction: "Heat pan and pour batter.", imageName: nil, timerDuration: 2),
                Step(order: 3, instruction: "Flip pancakes when bubbles appear. Cook until golden.", imageName: nil, timerDuration: 3)
            ],
            time: 15,
            servings: 3,
            category: "Breakfast",
            difficulty: Difficulty.easy,
            calories: 450
        ),
        
        Recipe(
            name: "Caesar Salad",
            description: "Crisp romaine lettuce with Caesar dressing and croutons.",
            imageName: "caesar.salad",
            ingredients: ["Romaine", "Croutons", "Parmesan", "Caesar dressing", "Chicken"],
            steps: [
                Step(order: 1, instruction: "Chop and wash the romaine lettuce.", imageName: nil, timerDuration: 3),
                Step(order: 2, instruction: "Grill chicken and slice thinly.", imageName: nil, timerDuration: 10),
                Step(order: 3, instruction: "Toss lettuce with dressing, chicken, croutons, and parmesan.", imageName: nil, timerDuration: 2)
            ],
            time: 15,
            servings: 2,
            category: "Salad",
            difficulty: Difficulty.medium,
            calories: 520
        )
    ]
}
