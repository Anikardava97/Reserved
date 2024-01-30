//
//  FavoritesManager.swift
//  Reserved
//
//  Created by Ani's Mac on 29.01.24.
//

import Foundation

final class FavoritesManager {
    static let shared = FavoritesManager()
    private init() {}
    
    var favoriteRestaurants: [Restaurant] = []
    
    func addFavorite(restaurant: Restaurant) {
        if !isFavorite(restaurant: restaurant) {
            favoriteRestaurants.append(restaurant)
        }
    }
    
    func removeFavorite(restaurant: Restaurant) {
        favoriteRestaurants.removeAll { $0.id == restaurant.id }
    }
    
    func isFavorite(restaurant: Restaurant) -> Bool {
        return favoriteRestaurants.contains { $0.id == restaurant.id }
    }
    
    func getAllFavorites() -> [Restaurant] {
        return favoriteRestaurants
    }
}
