//
//  FavoritesManager.swift
//  Reserved
//
//  Created by Ani's Mac on 29.01.24.
//

import Foundation

protocol FavoritesManagerDelegate: AnyObject {
    func favoritesManagerDidUpdateFavorites()
}

final class FavoritesManager {
    // MARK: - Shared Instance
    static let shared = FavoritesManager()
    
    // MARK: - Private Init
    private init() {}
    
    // MARK: - Properties
    var favoriteRestaurants: [Restaurant] = []
    
    // MARK: - Delegate
    weak var delegate: FavoritesManagerDelegate?
    
    // MARK: - Methods
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
