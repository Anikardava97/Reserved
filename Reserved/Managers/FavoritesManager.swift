//
//  FavoritesManager.swift
//  Reserved
//
//  Created by Ani's Mac on 29.01.24.
//

import UIKit
import FirebaseAuth

final class FavoritesManager {
    // MARK: - Shared Instance
    static let shared = FavoritesManager()
    
    // MARK: - Private Init
    private init() {}
    
    // MARK: - Properties
    var favoriteRestaurants: [Restaurant] = []
    
    // MARK: - Methods
    func addFavorite(restaurant: Restaurant) {
        if !isFavorite(restaurant: restaurant) {
            favoriteRestaurants.append(restaurant)
            saveFavoritesForCurrentUser()
        }
    }
    
    func removeFavorite(restaurant: Restaurant) {
        favoriteRestaurants.removeAll { $0.id == restaurant.id }
        saveFavoritesForCurrentUser()
    }
    
    func isFavorite(restaurant: Restaurant) -> Bool {
        return favoriteRestaurants.contains { $0.id == restaurant.id }
    }
    
    func getAllFavorites() -> [Restaurant] {
        return favoriteRestaurants
    }
    
    private func updateBadgeCounts() {
        DispatchQueue.main.async {
            guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return }
            guard let tabBarController = windowScene.windows.first(where: { $0.isKeyWindow })?.rootViewController as? TabBarController else { return }
            tabBarController.updateBadgeCounts()
        }
    }
}

// MARK: - Extension: Save and Load Favourites
extension FavoritesManager {
    func saveFavoritesForCurrentUser() {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        let key = UserDefaults.standard.keyForUserSpecificData(base: "favoriteRestaurants", userId: userId)
        do {
            let data = try JSONEncoder().encode(favoriteRestaurants)
            UserDefaults.standard.set(data, forKey: key)
            updateBadgeCounts()
        } catch {
            print("Error saving favourites for user \(userId): \(error)")
        }
    }
    
    func loadFavoritesForCurrentUser() {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        let key = UserDefaults.standard.keyForUserSpecificData(base: "favoriteRestaurants", userId: userId)
        guard let data = UserDefaults.standard.data(forKey: key) else { return }
        if let favourites = try? JSONDecoder().decode([Restaurant].self, from: data) {
            self.favoriteRestaurants = favourites
            updateBadgeCounts()
        } else {
            print("Failed to decode favourites for user \(userId).")
        }
    }
}
