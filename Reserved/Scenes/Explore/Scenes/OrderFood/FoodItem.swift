//
//  FoodItem.swift
//  Reserved
//
//  Created by Ani's Mac on 06.02.24.
//

import UIKit

struct FoodResponse: Decodable {
    let foodItems: [FoodItem]
}

struct FoodItem: Decodable {
    let id: String
    let name: String
    let price: Double
    let image: String
    let ingredients: String
    let category: String
    
    var selectedAmount: Int?
}

enum Category: String, Decodable {
    case food
    case dessert
    case drink
}
