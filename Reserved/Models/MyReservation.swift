//
//  MyReservation.swift
//  Reserved
//
//  Created by Ani's Mac on 29.01.24.
//

import Foundation

struct MyReservation: Codable {
    var restaurantName: String
    var reservationDate: String
    var reservationTime: String
    var guestsCount: Int
    var foodItems: [FoodItem]?
    var gift: FoodItem?
}
