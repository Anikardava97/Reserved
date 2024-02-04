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
class Restaurant: Codable {
    let id: Int
    let name: String
    let cuisine: String
    let mainImageURL: String?
    let images: [String]?
    let openHours: OpenHours
    let location: Location
    let description: String
    let websiteURL: String
    let menuURL: String
    let phoneNumber: String
    let reviewStars: Double
    var reservations: [Reservation]?
}

struct Location: Codable {
    let address: String
    let latitude, longitude: Double
}

struct Reservation: Codable {
    let date: String
    let time: String
    let guestCount: Int
    let tableNumber: Int
}

struct OpenHours: Codable {
    let monday, tuesday, wednesday, thursday, friday, saturday, sunday: Day
}

struct Day: Codable {
    let startTime: StartTime
    let endTime: EndTime
}

enum StartTime: String, Codable {
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

enum EndTime: String, Codable {
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


