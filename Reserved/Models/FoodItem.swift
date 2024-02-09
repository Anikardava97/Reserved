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
    let id: Int
    let name: String
    let price: Double
    let image: String?
    let ingredients: String
    var selectedAmount: Int?
}
