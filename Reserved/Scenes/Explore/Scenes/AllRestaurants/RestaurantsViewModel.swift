//
//  RestaurantsViewModel.swift
//  Reserved
//
//  Created by Ani's Mac on 19.01.24.
//

import Foundation

protocol RestaurantsViewModelDelegate: AnyObject {
    func restaurantsFetched(_ restaurants: [Restaurant])
    func showError(_ error: Error)
    func navigateToRestaurantDetails(with restaurant: Restaurant)
    func favoriteStatusChanged(for restaurant: Restaurant)
}

final class RestaurantsViewModel {
    // MARK: - Properties
    private let baseURL = Constants.URLs.restaurantsListURL
    private var restaurants: [Restaurant]?
    weak var delegate: RestaurantsViewModelDelegate?
    
    // MARK: - Methods
    func viewDidLoad() {
        fetchRestaurants()
    }
    
    private func fetchRestaurants() {
        NetworkManager.shared.fetch(from: baseURL) { [weak self] (result: Result<RestaurantResponse, NetworkError>) in
            switch result {
            case .success(let fetchedRestaurants):
                self?.restaurants = fetchedRestaurants.restaurants
                self?.delegate?.restaurantsFetched(fetchedRestaurants.restaurants)
            case .failure(let error):
                self?.delegate?.showError(error)
            }
        }
    }
    
    func navigateToRestaurantDetails(with restaurant: Restaurant) {
        delegate?.navigateToRestaurantDetails(with: restaurant)
    }
    
    func toggleFavorite(for restaurant: Restaurant) {
        let isFavorite = FavoritesManager.shared.isFavorite(restaurant: restaurant)
        if isFavorite {
            FavoritesManager.shared.removeFavorite(restaurant: restaurant)
        } else {
            FavoritesManager.shared.addFavorite(restaurant: restaurant)
        }
        delegate?.favoriteStatusChanged(for: restaurant)
    }
    
    func filterRestaurantsByCuisine(_ cuisine: String) -> [Restaurant] {
        guard let restaurants = restaurants else { return [] }
        switch cuisine {
        case "Georgian":
            return restaurants.filter { $0.cuisine == "Georgian" }
        case "Asian":
            return restaurants.filter { $0.cuisine == "Asian" }
        case "European":
            return restaurants.filter { $0.cuisine == "European" }
        default:
            return restaurants
        }
    }
}
