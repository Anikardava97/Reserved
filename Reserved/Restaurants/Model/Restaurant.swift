//
//  Restaurant.swift
//  Reserved
//
//  Created by Ani's Mac on 19.01.24.
//

import Foundation

struct Restaurant {
    let id: Int
    let name: String
    let cuisine: CuisineType
    let mainImageURL: URL
    let images: [URL]
    let openHours: [DayOfWeek: OpeningHours]
    let location: Location
    let description: String
    let websiteURL: URL?
    let menuURL: URL?
    let phoneNumber: String
    let reviewStars: Double
}

struct OpeningHours {
    let startTime: String
    let endTime: String
}

enum CuisineType: String {
    case georgian = "Georgian"
    case european = "European"
    case asian = "Asian"
}

struct Location {
    let address: String
    let latitude: Double
    let longitude: Double
}

enum DayOfWeek: Int {
    case monday, tuesday, wednesday, thursday, friday, saturday, sunday
}

// MARK: Mock Data
let onoRestaurant = Restaurant(
    id: 1,
    name: "Ono",
    cuisine: .georgian,
    mainImageURL: URL(string: "https://drive.google.com/file/d/1HFMpUomtBiVn76kUISmTP_EOZ1fbFZhV/view?usp=sharing")!,
    images: [
        URL(string: "https://drive.google.com/file/d/1HFMpUomtBiVn76kUISmTP_EOZ1fbFZhV/view?usp=sharing")!,
        URL(string: "https://drive.google.com/file/d/1Xcs0N_SvWVfmd8feT-eicUUy__GkkyHr/view?usp=sharing")!,
        URL(string: "https://drive.google.com/file/d/1zEajHz_Y1BGLoIM-TjSrH6IGzwHqlfEO/view?usp=sharing")!,
    ],
    openHours: [
        .monday: OpeningHours(startTime: "9: 00 AM", endTime: "2:00 AM"),
        .tuesday: OpeningHours(startTime: "9: 00 AM", endTime: "2:00 AM"),
        .wednesday: OpeningHours(startTime: "9: 00 AM", endTime: "2:00 AM"),
        .thursday: OpeningHours(startTime: "9: 00 AM", endTime: "2:00 AM"),
        .friday: OpeningHours(startTime: "9: 00 AM", endTime: "2:00 AM"),
        .saturday: OpeningHours(startTime: "9: 00 AM", endTime: "2:00 AM"),
        .sunday: OpeningHours(startTime: "9: 00 AM", endTime: "2:00 AM")
    ],
    location: Location(address: "45a Merab Kostava St, Tbilisi 0179", latitude: 41.709612, longitude: 44.784704),
    description: "A sample restaurant with delicious food.",
    websiteURL: URL(string: "https://hotelcoste.ge/"),
    menuURL: URL(string: "https://restaurantguru.com/ONO-Restaurant-Tbilisi/menu"),
    phoneNumber: "+995 511 19 11 00",
    reviewStars: 4.5
)


let stamba = Restaurant(
    id: 2,
    name: "Stamba",
    cuisine: .european,
    mainImageURL: URL(string: "https://drive.google.com/file/d/1AlASSOBROHzdMsU4_waTAJts5mMCKwuj/view?usp=sharing")!,
    images: [
        URL(string: "https://drive.google.com/file/d/1_4qGU6lZHzoZm0dnxVSakzfjf9mf5k6A/view?usp=sharing")!,
        URL(string: "https://drive.google.com/file/d/1TdkEF-8_8LuC3tu1z1Sp7qk4bfndB3vB/view?usp=sharing")!,
        URL(string: "https://drive.google.com/file/d/1s2q352fzHB0tJWMTBwCwPcrK69P7371v/view?usp=sharing")!,
    ],
    openHours: [
        .monday: OpeningHours(startTime: "8: 00 AM", endTime: "2:00 AM"),
        .tuesday: OpeningHours(startTime: "8: 00 AM", endTime: "2:00 AM"),
        .wednesday: OpeningHours(startTime: "8: 00 AM", endTime: "2:00 AM"),
        .thursday: OpeningHours(startTime: "8: 00 AM", endTime: "2:00 AM"),
        .friday: OpeningHours(startTime: "8: 00 AM", endTime: "2:00 AM"),
        .saturday: OpeningHours(startTime: "8: 00 AM", endTime: "2:00 AM"),
        .sunday: OpeningHours(startTime: "8: 00 AM", endTime: "2:00 AM")
    ],
    location: Location(address: "14 Kostava St. 0108 Tbilisi, Georgia", latitude: 41.68026, longitude: 44.982812),
    description: "A sample restaurant with delicious food.",
    websiteURL: URL(string: "https://www.facebook.com/cafe.stamba"),
    menuURL: URL(string: "https://restaurantguru.com/Stamba-Tbilisi/menu"),
    phoneNumber: "+995 322 02 19 99",
    reviewStars: 4.3
)

let siangan = Restaurant(
    id: 3,
    name: "Sian-Gan",
    cuisine: .asian,
    mainImageURL: URL(string: "https://drive.google.com/file/d/1XB9dC7j-8wKrH0eYpm6G1eM2528p8KEa/view?usp=sharing")!,
    images: [
        URL(string: "https://drive.google.com/file/d/1XB9dC7j-8wKrH0eYpm6G1eM2528p8KEa/view?usp=sharing")!,
        URL(string: "https://drive.google.com/file/d/1e5RI9_n2joo2EuYq9lSquHYqOfieY1O6/view?usp=sharing")!,
        URL(string: "https://drive.google.com/file/d/1KnxfRdgLRI3s4JTMVq6O8rbitqIb9mBV/view?usp=sharing")!,
    ],
    openHours: [
        .monday: OpeningHours(startTime: "12: 00 PM", endTime: "12:00 AM"),
        .tuesday: OpeningHours(startTime: "12: 00 PM", endTime: "12:00 AM"),
        .wednesday: OpeningHours(startTime: "12: 00 PM", endTime: "12:00 AM"),
        .thursday: OpeningHours(startTime: "12: 00 PM", endTime: "12:00 AM"),
        .friday: OpeningHours(startTime: "12: 00 PM", endTime: "12:00 AM"),
        .saturday: OpeningHours(startTime: "12: 00 PM", endTime: "12:00 AM"),
        .sunday: OpeningHours(startTime: "12: 00 PM", endTime: "12:00 AM"),
    ],
    location: Location(address: "Pekini Ave., 41, Tbilisi 0161 Georgia", latitude: 41.73028509355174, longitude: 44.76865887022742),
    description: "A sample restaurant with delicious food.",
    websiteURL: URL(string: "https://www.facebook.com/RestaurantSiangGan"),
    menuURL: URL(string: "https://glovoapp.com/ge/en/tbilisi/siangani-tbi/"),
    phoneNumber: "+995 322 37 96 88",
    reviewStars: 3.5
)
