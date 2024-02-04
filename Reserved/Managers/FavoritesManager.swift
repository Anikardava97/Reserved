//
//  FavoritesManager.swift
//  Reserved
//
//  Created by Ani's Mac on 29.01.24.
//

import Foundation
import FirebaseAuth

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
    weak var delegate: FavoritesManagerDelegate?
    
    // MARK: - Methods
    func addFavorite(restaurant: Restaurant) {
        if !isFavorite(restaurant: restaurant) {
            favoriteRestaurants.append(restaurant)
            delegate?.favoritesManagerDidUpdateFavorites()
            saveFavoritesForCurrentUser()
        }
    }
    
    func removeFavorite(restaurant: Restaurant) {
        favoriteRestaurants.removeAll { $0.id == restaurant.id }
        delegate?.favoritesManagerDidUpdateFavorites()
        saveFavoritesForCurrentUser()
    }
    
    func isFavorite(restaurant: Restaurant) -> Bool {
        return favoriteRestaurants.contains { $0.id == restaurant.id }
    }
    
    func getAllFavorites() -> [Restaurant] {
        return favoriteRestaurants
    }
}

// MARK: - Extension: Save and Load Favorites
extension FavoritesManager {
    func saveFavoritesForCurrentUser() {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        let key = UserDefaults.standard.keyForUserSpecificData(base: "favoriteRestaurants", userId: userId)
        do {
            let data = try JSONEncoder().encode(favoriteRestaurants)
            UserDefaults.standard.set(data, forKey: key)
        } catch {
            print("Error saving favorites for user \(userId): \(error)")
        }
    }

    func loadFavoritesForCurrentUser() {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        let key = UserDefaults.standard.keyForUserSpecificData(base: "favoriteRestaurants", userId: userId)
        guard let data = UserDefaults.standard.data(forKey: key) else { return }
        if let favorites = try? JSONDecoder().decode([Restaurant].self, from: data) {
            self.favoriteRestaurants = favorites
        } else {
            print("Failed to decode favorites for user \(userId).")
        }
    }
}
