//
//  Restaurant.swift
//  Reserved
//
//  Created by Ani's Mac on 19.01.24.
//

import Foundation

// MARK: - RestaurantResponse
struct RestaurantResponse: Decodable {
    let restaurants: [Restaurant]
}

// MARK: - Restaurant
struct Restaurant: Decodable {
    let id: Int
    let name: String
    let cuisine: String
    let mainImageURL: String
    let images: [String]
    let openHours: OpenHours
    let location: Location
    let description: String
    let websiteURL: String
    let menuURL: String
    let phoneNumber: String
    let reviewStars: Double
    var reviews: [Review]
    var tables: [Table]
}

struct OpenHours: Decodable {
    let monday, tuesday, wednesday, thursday, friday, saturday, sunday: Day
}

struct Location: Decodable {
    let address: String
    let latitude, longitude: Double
}

struct Review: Codable {
    let username: String
    let rating: Double
    let comment: String
}

struct Table: Codable {
    let tableID: Int
    let tableNumber: Int
    let capacity: Int
    var isAvailable: Bool
    var reservations: [Reservation]
}

struct Reservation: Codable {
    let restaurantID: Int
    let tableID: Int
    let date: Date
    let numberOfGuests: Int
}


struct Day: Decodable {
    let startTime: StartTime
    let endTime: EndTime
}

enum StartTime: String, Decodable {
    case the800Am = "8:00 AM"
    case the900Am = "9:00 AM"
    case the1000Am = "10:00 AM"
    case the1100Am = "11:00 AM"
    case the1200Pm = "12:00 PM"
    case the100Pm = "1:00 PM"
    case the200Pm = "2:00 PM"
    case the300Pm = "3:00 PM"
}

enum EndTime: String, Decodable {
    case the800Pm = "8:00 PM"
    case the830Pm = "8:30 PM"
    case the900Pm = "9:00 PM"
    case the930Pm = "9:30 PM"
    case the1000Pm = "10:00 PM"
    case the1030Pm = "10:30 PM"
    case the1100Pm = "11:00 PM"
    case the1130Pm = "11:30 PM"
    case the1200Am = "12:00 AM"
    case the100Am = "1:00 AM"
    case the200Am = "2:00 AM"
    case the300Am = "3:00 AM"
}

//struct User {
//    let uid: String
//    var reservations: [Reservation]
//    var reservedTables: [Table]
//    var favoriteRestaurants: [Restaurant]
//}

// MARK: - Mock Info
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
        saturday: Day(startTime: .the800Am, endTime: .the1200Am),
        sunday: Day(startTime: .the800Am, endTime: .the1200Am)
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
    reviewStars: 4.0, 
    reviews: [],
    tables: [
            Table(tableID: 1, tableNumber: 1, capacity: 4, isAvailable: true, reservations: []),
            Table(tableID: 2, tableNumber: 2, capacity: 2, isAvailable: true, reservations: []),
            Table(tableID: 3, tableNumber: 3, capacity: 6, isAvailable: true, reservations: []),
            Table(tableID: 4, tableNumber: 4, capacity: 3, isAvailable: true, reservations: []),
            Table(tableID: 5, tableNumber: 5, capacity: 5, isAvailable: true, reservations: []),
            Table(tableID: 6, tableNumber: 6, capacity: 6, isAvailable: true, reservations: []),
            Table(tableID: 7, tableNumber: 7, capacity: 7, isAvailable: true, reservations: []),
            Table(tableID: 8, tableNumber: 8, capacity: 8, isAvailable: true, reservations: []),
            Table(tableID: 9, tableNumber: 9, capacity: 9, isAvailable: true, reservations: []),
            Table(tableID: 10, tableNumber: 10, capacity: 10, isAvailable: true, reservations: []),
            Table(tableID: 11, tableNumber: 11, capacity: 11, isAvailable: true, reservations: []),
            Table(tableID: 12, tableNumber: 12, capacity: 12, isAvailable: true, reservations: []),
        ]
)

