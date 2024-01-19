//
//  Restaurant.swift
//  Reserved
//
//  Created by Ani's Mac on 19.01.24.
//

import Foundation

// MARK: - Empty
struct RestaurantResponse: Decodable {
    let restaurants: [Restaurant]
}

// MARK: - Restaurant
struct Restaurant: Decodable {
    let id: Int
    let name, cuisine: String
    let mainImageURL: String
    let images: [String]
    let openHours: OpenHours
    let location: Location
    let description: String
    let websiteURL: String
    let menuURL: String
    let phoneNumber: String
    let reviewStars: Double
}

// MARK: - Location
struct Location: Decodable {
    let address: String
    let latitude, longitude: Double
}

// MARK: - OpenHours
struct OpenHours: Decodable {
    let monday, tuesday, wednesday, thursday: Day
    let friday, saturday, sunday: Day
}

// MARK: - Day
struct Day: Decodable {
    let startTime: StartTime
    let endTime: EndTime
}

enum EndTime: String, Decodable {
    case the1200Am = "12:00 AM"
    case the200Am = "2:00 AM"
}

enum StartTime: String, Decodable {
    case the1200Pm = "12: 00 PM"
    case the800Am = "8: 00 AM"
    case the900Am = "9: 00 AM"
}
