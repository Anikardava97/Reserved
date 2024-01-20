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

let mockRestaurant = Restaurant(
    id: 1,
    name: "Gourmet Haven",
    cuisine: "European",
    mainImageURL: "https://example.com/images/main.jpg",
    images: [
        "https://example.com/images/image1.jpg",
        "https://example.com/images/image2.jpg",
        "https://example.com/images/image3.jpg"
    ],
    openHours: OpenHours(
        monday: Day(startTime: .the900Am, endTime: .the1200Am),
        tuesday: Day(startTime: .the900Am, endTime: .the1200Am),
        wednesday: Day(startTime: .the900Am, endTime: .the1200Am),
        thursday: Day(startTime: .the900Am, endTime: .the1200Am),
        friday: Day(startTime: .the800Am, endTime: .the200Am),
        saturday: Day(startTime: .the800Am, endTime: .the200Am),
        sunday: Day(startTime: .the800Am, endTime: .the200Am)
    ),
    location: Location(
        address: "45a Merab Kostava St, Tbilisi 0179",
        latitude: 41.70911855004739,
        longitude: 44.78554397976136
    ),
    description: "Gourmet Haven offers a unique blend of modern European cuisine with a local twist. Enjoy our chef's specials in a cozy and elegant setting.",
    websiteURL: "https://gourmethaven.com",
    menuURL: "https://gourmethaven.com/menu",
    phoneNumber: "1234567890",
    reviewStars: 4.5
)
