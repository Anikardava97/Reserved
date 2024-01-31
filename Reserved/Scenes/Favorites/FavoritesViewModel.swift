//
//  FavoritesViewModel.swift
//  Reserved
//
//  Created by Ani's Mac on 30.01.24.
//

import Foundation

final class FavoritesViewModel {
    // MARK: - Properties
    private var favorites: [Restaurant] {
        didSet {
            self.onFavoritesUpdated?()
        }
    }

    var onFavoritesUpdated: (() -> Void)?

    // MARK: - Init
    init(favorites: [Restaurant] = []) {
        self.favorites = favorites
    }

    // MARK: - Methods
    func loadFavorites() {
        self.favorites = FavoritesManager.shared.getAllFavorites()
    }

    func toggleFavorite(restaurant: Restaurant) {
        if isFavorite(restaurant: restaurant) {
            FavoritesManager.shared.removeFavorite(restaurant: restaurant)
        } else {
            FavoritesManager.shared.addFavorite(restaurant: restaurant)
        }
        loadFavorites()
    }

    func isFavorite(restaurant: Restaurant) -> Bool {
        return FavoritesManager.shared.isFavorite(restaurant: restaurant)
    }

    var numberOfFavorites: Int {
        return favorites.count
    }

    func favoriteAt(index: Int) -> Restaurant {
        return favorites[index]
    }
}