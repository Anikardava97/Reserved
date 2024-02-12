//
//  FoodItem.swift
//  Reserved
//
//  Created by Ani's Mac on 06.02.24.
//

import UIKit

// MARK: - Food Response
struct FoodResponse: Codable {
    let foodItems: [FoodItem]
}

// MARK: - FoodItem
struct FoodItem: Codable {
    let id: Int
    let name: String
    let price: Double
    let image: String?
    let ingredients: String
    var selectedAmount: Int?
}
