//
//  GroceryEmojiMap.swift
//  SmartShopper
//
//  Created by AlexBezkopylnyi on 06.05.2025.
//

import Foundation

let groceryDefaultItems: [GroceryItem] = [
    GroceryItem(name: "apple", category: .fruits, stores: []),
    GroceryItem(name: "banana", category: .fruits, stores: []),
    GroceryItem(name: "lemon", category: .fruits, stores: []),
    GroceryItem(name: "avocado", category: .fruits, stores: []),
    GroceryItem(name: "orange", category: .fruits, stores: []),
    GroceryItem(name: "mango", category: .fruits, stores: []),
    GroceryItem(name: "kiwi", category: .fruits, stores: []),
    GroceryItem(name: "potato", category: .vegetables, stores: []),
    GroceryItem(name: "garlic", category: .vegetables, stores: []),
    GroceryItem(name: "tomato", category: .vegetables, stores: []),
    GroceryItem(name: "olives", category: .vegetables, stores: []),
    GroceryItem(name: "onion", category: .vegetables, stores: []),
    GroceryItem(name: "pepper", category: .vegetables, stores: []),
    GroceryItem(name: "cherry", category: .vegetables, stores: []),
    GroceryItem(name: "mushrooms", category: .vegetables, stores: []),
    GroceryItem(name: "carrot", category: .vegetables, stores: []),
    GroceryItem(name: "zucchini", category: .vegetables, stores: []),
    GroceryItem(name: "pickled cucumbers", category: .vegetables, stores: []),
    GroceryItem(name: "sweet potato", category: .vegetables, stores: []),
    GroceryItem(name: "beetroot", category: .vegetables, stores: []),
    GroceryItem(name: "eggs", category: .meat, stores: []),
    GroceryItem(name: "chicken breast", category: .meat, stores: []),
    GroceryItem(name: "chicken wings", category: .meat, stores: []),
    GroceryItem(name: "chicken legs", category: .meat, stores: []),
    GroceryItem(name: "chicken", category: .meat, stores: []),
    GroceryItem(name: "bacon", category: .meat, stores: []),
    GroceryItem(name: "minced meat", category: .meat, stores: []),
    GroceryItem(name: "meat", category: .meat, stores: []),
    GroceryItem(name: "salmon", category: .fish, stores: []),
    GroceryItem(name: "dorado", category: .fish, stores: []),
    GroceryItem(name: "robalo", category: .fish, stores: []),
    GroceryItem(name: "noodles", category: .cerealAndPasta, stores: []),
    GroceryItem(name: "macaroni", category: .cerealAndPasta, stores: []),
    GroceryItem(name: "rice", category: .cerealAndPasta, stores: []),
    GroceryItem(name: "salt", category: .seasoning, stores: []),
    GroceryItem(name: "sugar", category: .seasoning, stores: []),
    GroceryItem(name: "bay leaf", category: .seasoning, stores: []),
    GroceryItem(name: "tomato paste", category: .seasoning, stores: []),
    GroceryItem(name: "bouillon", category: .seasoning, stores: []),
    GroceryItem(name: "sesame", category: .seasoning, stores: []),
    GroceryItem(name: "turmeric", category: .spices, stores: []),
    GroceryItem(name: "black pepper", category: .spices, stores: []),
    GroceryItem(name: "butter", category: .unCategorized, stores: []),
    GroceryItem(name: "bread", category: .unCategorized, stores: []),
    GroceryItem(name: "tofu", category: .unCategorized, stores: []),
    GroceryItem(name: "olive oil", category: .unCategorized, stores: []),
    GroceryItem(name: "coconut oil", category: .unCategorized, stores: []),
    GroceryItem(name: "greens", category: .unCategorized, stores: []),
    GroceryItem(name: "pesto", category: .unCategorized, stores: []),
    GroceryItem(name: "cheese", category: .unCategorized, stores: []),
    GroceryItem(name: "soy sauce", category: .unCategorized, stores: []),
    GroceryItem(name: "honey", category: .unCategorized, stores: []),
    GroceryItem(name: "mustard", category: .unCategorized, stores: []),
    GroceryItem(name: "flour", category: .unCategorized, stores: []),
    GroceryItem(name: "teriyaki sauce", category: .unCategorized, stores: []),
    GroceryItem(name: "bbq", category: .unCategorized, stores: []),
    GroceryItem(name: "sunflower oil", category: .unCategorized, stores: []),
    GroceryItem(name: "lemon water", category: .unCategorized, stores: []),
    GroceryItem(name: "toilet paper", category: .unCategorized, stores: []),
    GroceryItem(name: "cotton buds", category: .unCategorized, stores: []),
    GroceryItem(name: "toothpaste", category: .unCategorized, stores: []),
    GroceryItem(name: "body gel", category: .unCategorized, stores: []),
    GroceryItem(name: "soap", category: .unCategorized, stores: []),
    GroceryItem(name: "wet wipes", category: .unCategorized, stores: []),
    GroceryItem(name: "cotton pads", category: .unCategorized, stores: []),
    GroceryItem(name: "detergent", category: .unCategorized, stores: []),
    GroceryItem(name: "kitchen paper", category: .unCategorized, stores: []),
    GroceryItem(name: "mold cleaner", category: .unCategorized, stores: []),
    GroceryItem(name: "sponge", category: .unCategorized, stores: []),
    GroceryItem(name: "rag", category: .unCategorized, stores: []),
    GroceryItem(name: "dish soap", category: .unCategorized, stores: []),
    GroceryItem(name: "foil", category: .unCategorized, stores: []),
    GroceryItem(name: "ice cream", category: .sweat, stores: []),
    GroceryItem(name: "vinho verde", category: .drinks, stores: []),
    GroceryItem(name: "red wine", category: .drinks, stores: []),
    GroceryItem(name: "mint tea", category: .drinks, stores: []),
    GroceryItem(name: "milk", category: .drinks, stores: [])
]

let groceryEmojiMap: [String: String] = [

    // Fruits
    "apple": "🍎",
    "banana": "🍌",
    "lemon": "🍋",
    "avocado": "🥑",
    "orange": "🍊",
    "mango": "🥭",
    "kiwi": "🥝",

    // Vegetables
    "potato": "🥔",
    "garlic": "🧄",
    "tomato": "🍅",
    "olives": "🫒",
    "onion": "🧅",
    "pepper": "🫑",
    "cherry": "🍒",
    "mushrooms": "🍄",
    "carrot": "🥕",
    "zucchini": "🥒",
    "pickled cucumbers": "🥒",
    "sweet potato": "🍠",
    "beetroot": "",

    // Meat / Fish
    "eggs": "🥚",
    "chicken breast": "🍗",
    "chicken wings": "🍗",
    "chicken legs": "🍗",
    "chicken": "🍗",
    "salmon": "🍣",
    "dorado": "🐟",
    "robalo": "🐟",
    "minced meat": "🥩",
    "bacon": "🥓",
    "meat": "🥩",

    // Cereals / Pasta
    "noodles": "🍜",
    "macaroni": "🍝",
    "rice": "🍚",

    // Seasoning
    "salt": "🧂",
    "sugar": "🍬",
    "bay leaf": "🌿",
    "tomato paste": "🍅",
    "bouillon": "🥣",
    "sesame": "",

    // Spices
    "turmeric (куркума)": "",
    "black pepper": "🌶️",

    // Other
    "butter": "🧈",
    "bread": "🍞",
    "tofu": "🧊",
    "olive oil": "🫒",
    "coconut oil": "🥥",
    "greens": "🥬",
    "pesto": "🌿",
    "cheese": "🧀",
    "soy sauce": "🧂",
    "honey": "🍯",
    "mustard": "🌭",
    "flour": "🌾",
    "teriyaki sauce": "🍶",
    "bbq": "🔥",
    "sunflower oil": "🌻",
    "lemon water": "🍋💧",

    // Bathroom / Toilet
    "toilet paper": "🧻",
    "cotton buds": "🪥",
    "toothpaste": "🦷",
    "body gel": "🧴",
    "soap": "🧼",
    "wet wipes": "🧻",
    "cotton pads": "💿",
    "detergent": "🧺",

    // Kitchen
    "kitchen paper": "📄",
    "mold cleaner": "🧼",
    "sponge": "🧽",
    "rag": "🪣",
    "dish soap": "🧴",
    "foil": "📦",

    // Sweets
    "ice cream": "🍦",

    // Drinks
    "vinho verde": "🍷",
    "red wine": "🍷",
    "mint tea": "🌿",
    "milk": "🥛"
]
