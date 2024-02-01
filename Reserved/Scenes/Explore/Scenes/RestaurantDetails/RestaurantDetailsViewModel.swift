//
//  RestaurantDetailsViewModel.swift
//  Reserved
//
//  Created by Ani's Mac on 01.02.24.
//

import Foundation

final class RestaurantDetailsViewModel {
    // MARK: - Properties
    var restaurant: Restaurant?
    
    // MARK: - Computed Properties
    var images: [String]? {
        return restaurant?.images
    }
    
    var restaurantName: String {
        return restaurant?.name ?? ""
    }
    
    var cuisine: String {
        return restaurant?.cuisine ?? ""
    }
    
    var reviewStars: String {
        return String(restaurant?.reviewStars ?? 0)
    }
    
    var websiteURL: String? {
        return restaurant?.websiteURL ?? ""
    }
    
    var menuURL: String? {
        return restaurant?.menuURL ?? ""
    }
    
    var isOpenNow: Bool {
        guard let restaurant else { return false }
        return RestaurantHoursManager.isRestaurantOpen(from: restaurant)
    }
    
    var openingHours: String {
        guard let restaurant else { return "" }
        return RestaurantHoursManager.getTodaysOpeningHours(from: restaurant)
    }
    
    var description: String {
        return restaurant?.description ?? ""
    }
    
    var address: String {
        return restaurant?.location.address ?? ""
    }
    
    var longitude: Double {
        return restaurant?.location.longitude ?? 0.0
    }
    
    var latitude: Double {
        return restaurant?.location.latitude ?? 0.0
    }
    
    var phoneNumber: String {
        return restaurant?.phoneNumber ?? ""
    }
    
    // MARK: - Init
    init(restaurant: Restaurant) {
        self.restaurant = restaurant
    }
}
