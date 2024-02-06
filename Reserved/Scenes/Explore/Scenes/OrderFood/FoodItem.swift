//
//  FoodItem.swift
//  Reserved
//
//  Created by Ani's Mac on 06.02.24.
//

import UIKit

struct FoodItem {
    let id: String
    let name: String
    let price: Double
    let image: UIImage!
    let ingredients: [String]
    let calories: Int
    let grams: Int
    let category: Category
}

enum Category {
    case food
    case dessert
    case drink
}

let foodItem1 = FoodItem(
    id: "1",
    name: "Margherita Pizza",
    price: 9.99,
    image: UIImage(named: "margherita_pizza"),
    ingredients: ["Tomato sauce", "Mozzarella cheese", "Fresh basil"],
    calories: 250,
    grams: 300,
    category: .food
)

let foodItem2 = FoodItem(
    id: "2",
    name: "Chicken Caesar Salad",
    price: 8.49,
    image: UIImage(named: "caesar_salad"),
    ingredients: ["Grilled chicken", "Romaine lettuce", "Parmesan cheese", "Caesar dressing"],
    calories: 320,
    grams: 200,
    category: .food
)

let foodItem3 = FoodItem(
    id: "3",
    name: "Chocolate Brownie",
    price: 4.99,
    image: UIImage(named: "chocolate_brownie"),
    ingredients: ["Chocolate", "Flour", "Sugar", "Eggs"],
    calories: 400,
    grams: 150,
    category: .dessert
)

let drinkItem = FoodItem(
    id: "4",
    name: "Orange Juice",
    price: 2.49,
    image: UIImage(named: "orange_juice"),
    ingredients: ["Fresh oranges"],
    calories: 120,
    grams: 250,
    category: .drink
)
