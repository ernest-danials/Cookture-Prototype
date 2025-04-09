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
            ingredients: [
                .init(amount: "one pack of", name: "Spaghetti"),
                .init(amount: "one pack of", name: "Ground beef"),
                .init(amount: "one cup of", name: "Tomato sauce"),
                .init(amount: "one", name: "Onion"),
                .init(amount: "2 cloves of", name: "Garlic")
            ],
            steps: [
                Step(order: 1, instruction: "Boil spaghetti until al dente.", imageName: nil, timerDuration: 10),
                Step(order: 2, instruction: "Cook ground beef until browned.", imageName: "spaghetti.bolognese.step.no.2", timerDuration: nil),
                Step(order: 3, instruction: "Add tomato sauce, onion, and garlic. Simmer.", imageName: nil, timerDuration: nil)
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
            ingredients: [
                .init(amount: "2 slices of", name: "Bread"),
                .init(amount: "1 ripe", name: "Avocado"),
                .init(amount: "1/4 teaspoon of", name: "Salt"),
                .init(amount: "1/4 teaspoon of", name: "Pepper"),
                .init(amount: "1/2", name: "Lemon")
            ],
            steps: [
                Step(order: 1, instruction: "Toast the bread.", imageName: nil, timerDuration: 3),
                Step(order: 2, instruction: "Mash avocado with salt, pepper, and lemon juice.", imageName: nil, timerDuration: nil),
                Step(order: 3, instruction: "Spread mixture on toast and serve.", imageName: nil, timerDuration: nil)
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
            ingredients: [
                .init(amount: "500g of", name: "Chicken"),
                .init(amount: "2 tablespoons of", name: "Curry powder"),
                .init(amount: "1 large", name: "Onion"),
                .init(amount: "2", name: "Tomatoes"),
                .init(amount: "1 can of", name: "Coconut milk")
            ],
            steps: [
                Step(order: 1, instruction: "Sauté onions until golden.", imageName: nil, timerDuration: nil),
                Step(order: 2, instruction: "Add chicken and cook thoroughly.", imageName: nil, timerDuration: nil),
                Step(order: 3, instruction: "Stir in spices, tomato, and coconut milk. Simmer.", imageName: nil, timerDuration: nil)
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
            ingredients: [
                .init(amount: "1 cup of", name: "Flour"),
                .init(amount: "1 cup of", name: "Milk"),
                .init(amount: "1", name: "Egg"),
                .init(amount: "1 teaspoon of", name: "Baking powder"),
                .init(amount: "2 tablespoons of", name: "Sugar")
            ],
            steps: [
                Step(order: 1, instruction: "Mix dry and wet ingredients into a batter.", imageName: nil, timerDuration: nil),
                Step(order: 2, instruction: "Heat pan and pour batter.", imageName: nil, timerDuration: nil),
                Step(order: 3, instruction: "Flip pancakes when bubbles appear. Cook until golden.", imageName: nil, timerDuration: nil)
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
            ingredients: [
                .init(amount: "1 head of", name: "Romaine"),
                .init(amount: "1 cup of", name: "Croutons"),
                .init(amount: "1/2 cup of", name: "Parmesan"),
                .init(amount: "1/3 cup of", name: "Caesar dressing"),
                .init(amount: "1", name: "Chicken breast")
            ],
            steps: [
                Step(order: 1, instruction: "Chop and wash the romaine lettuce.", imageName: nil, timerDuration: nil),
                Step(order: 2, instruction: "Grill chicken and slice thinly.", imageName: nil, timerDuration: nil),
                Step(order: 3, instruction: "Toss lettuce with dressing, chicken, croutons, and parmesan.", imageName: nil, timerDuration: nil)
            ],
            time: 15,
            servings: 2,
            category: "Salad",
            difficulty: Difficulty.medium,
            calories: 520
        )
    ]
}
