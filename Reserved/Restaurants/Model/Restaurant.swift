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
    var reservations: [Reservation]?
}

struct OpenHours: Decodable {
    let monday, tuesday, wednesday, thursday, friday, saturday, sunday: Day
}

struct Location: Decodable {
    let address: String
    let latitude, longitude: Double
}

struct Reservation: Decodable {
    let date: String
    let time: String
    let guestCount: Int
    let tableNumber: Int
}

struct Day: Decodable {
    let startTime: StartTime
    let endTime: EndTime
}

enum StartTime: String, Decodable {
    case the800Am = "8:00 AM"
    case the830Am = "8:30 AM"
    case the900Am = "9:00 AM"
    case the930Am = "9:30 AM"
    case the1000Am = "10:00 AM"
    case the1030Am = "10:30 AM"
    case the1100Am = "11:00 AM"
    case the1130Am = "11:30 AM"
    case the1200Pm = "12:00 PM"
    case the1230Pm = "12:30 PM"
    case the100Pm = "1:00 PM"
    case the130Pm = "1:30 PM"
    case the200Pm = "2:00 PM"
    case the230Pm = "2:30 PM"
    case the300Pm = "3:00 PM"
    case the330Pm = "3:30 PM"
    case the400Pm = "4:00 PM"
    case the430Pm = "4:30 PM"
    case the500Pm = "5:00 PM"
    case the530Pm = "5:30 PM"
    case the600Pm = "6:00 PM"
    case the630Pm = "6:30 PM"
    case the700Pm = "7:00 PM"
    case the730Pm = "7:30 PM"
    case the800Pm = "8:00 PM"
    case the830Pm = "8:30 PM"
    case the900Pm = "9:00 PM"
    case the930Pm = "9:30 PM"
    case the1000Pm = "10:00 PM"
    case the1030Pm = "10:30 PM"
    case the1100Pm = "11:00 PM"
    case the1130Pm = "11:30 PM"
    case the1200Am = "12:00 AM"
    case the1230Am = "12:30 AM"
    case the100Am = "1:00 AM"
    case the130Am = "1:30 AM"
    case the200Am = "2:00 AM"
    case the230Am = "2:30 AM"
    case the300Am = "3:00 AM"
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
    case the1145Pm = "11:45 PM"
    case the1200Pm = "12:00 PM"
    case the1200Am = "12:00 AM"
    case the1230Am = "12:30 AM"
    case the1240Pm = "12:40 PM"
    case the1250Pm = "12:50 PM"
    case the100Am = "1:00 AM"
    case the130Am = "1:30 AM"
    case the200Am = "2:00 AM"
    case the230Am = "2:30 AM"
    case the300Am = "3:00 AM"
    case the330Am = "3:30 AM"
    case the400Am = "4:00 AM"
    case the430Am = "4:30 AM"
    case the500Am = "5:00 AM"
    case the530Am = "5:30 AM"
    case the600Am = "6:00 AM"
    case the630Am = "6:30 AM"
    case the700Am = "7:00 AM"
    case the730Am = "7:30 AM"
    case the800Am = "8:00 AM"
    case the830Am = "8:30 AM"
    case the900Am = "9:00 AM"
    case the930Am = "9:30 AM"
    case the1000Am = "10:00 AM"
    case the1030Am = "10:30 AM"
    case the100Pm = "1:00 PM"
    case the200Pm = "2:00 PM" 
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
    name: "Stamba",
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
    reviewStars: 4.0
    //reviews: [],
//    tables: [
//            Table(tableID: 1, tableNumber: 1, capacity: 12, isAvailable: true, reservations: []),
//            Table(tableID: 2, tableNumber: 2, capacity: 2, isAvailable: true, reservations: []),
//            Table(tableID: 3, tableNumber: 3, capacity: 8, isAvailable: true, reservations: []),
//            Table(tableID: 4, tableNumber: 4, capacity: 9, isAvailable: true, reservations: []),
//            Table(tableID: 5, tableNumber: 5, capacity: 6, isAvailable: true, reservations: []),
//            Table(tableID: 6, tableNumber: 6, capacity: 4, isAvailable: true, reservations: []),
//            Table(tableID: 7, tableNumber: 7, capacity: 10, isAvailable: true, reservations: []),
//            Table(tableID: 8, tableNumber: 8, capacity: 3, isAvailable: true, reservations: []),
//            Table(tableID: 9, tableNumber: 9, capacity: 2, isAvailable: true, reservations: []),
//            Table(tableID: 10, tableNumber: 10, capacity: 5, isAvailable: true, reservations: []),
//            Table(tableID: 11, tableNumber: 11, capacity: 7, isAvailable: true, reservations: []),
//            Table(tableID: 12, tableNumber: 12, capacity: 1, isAvailable: true, reservations: []),
//            Table(tableID: 13, tableNumber: 13, capacity: 11, isAvailable: true, reservations: []),
//            Table(tableID: 14, tableNumber: 14, capacity: 5, isAvailable: true, reservations: []),
//            Table(tableID: 15, tableNumber: 15, capacity: 2, isAvailable: true, reservations: []),
//            Table(tableID: 16, tableNumber: 16, capacity: 3, isAvailable: true, reservations: []),
//            Table(tableID: 17, tableNumber: 17, capacity: 8, isAvailable: true, reservations: []),
//            Table(tableID: 18, tableNumber: 18, capacity: 4, isAvailable: true, reservations: []),
//            Table(tableID: 19, tableNumber: 19, capacity: 12, isAvailable: true, reservations: []),
//            Table(tableID: 20, tableNumber: 20, capacity: 9, isAvailable: true, reservations: []),
//            Table(tableID: 21, tableNumber: 21, capacity: 6, isAvailable: true, reservations: []),
//            Table(tableID: 22, tableNumber: 22, capacity: 10, isAvailable: true, reservations: []),
//            Table(tableID: 23, tableNumber: 23, capacity: 1, isAvailable: true, reservations: []),
//            Table(tableID: 24, tableNumber: 24, capacity: 7, isAvailable: true, reservations: []),
//        ]
)
