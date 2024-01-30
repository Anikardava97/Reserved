//
//  FavoritesManager.swift
//  Reserved
//
//  Created by Ani's Mac on 29.01.24.
//

protocol FavoritesManagerDelegate: AnyObject {
    func favoritesManagerDidUpdateFavorites()
}

import Foundation

final class FavoritesManager {
    static let shared = FavoritesManager()
    private init() {}
    
    var favoriteRestaurants: [Restaurant] = []
    weak var delegate: FavoritesManagerDelegate?
    
    func addFavorite(restaurant: Restaurant) {
        if !isFavorite(restaurant: restaurant) {
            favoriteRestaurants.append(restaurant)
            delegate?.favoritesManagerDidUpdateFavorites()
        }
    }
    
    func removeFavorite(restaurant: Restaurant) {
        favoriteRestaurants.removeAll { $0.id == restaurant.id }
        delegate?.favoritesManagerDidUpdateFavorites()
    }
    
    func isFavorite(restaurant: Restaurant) -> Bool {
        return favoriteRestaurants.contains { $0.id == restaurant.id }
    }
    
    func getAllFavorites() -> [Restaurant] {
        return favoriteRestaurants
    }
}
