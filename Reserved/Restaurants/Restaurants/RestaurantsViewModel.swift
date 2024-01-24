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
}

final class RestaurantsViewModel {
    // MARK: - Properties
    private var restaurants: [Restaurant]?
    
    weak var delegate: RestaurantsViewModelDelegate?
    
    // MARK: - Methods
    func viewDidLoad() {
        fetchRestaurants()
    }
    
    func navigateToRestaurantDetails(with restaurant: Restaurant) {
        delegate?.navigateToRestaurantDetails(with: restaurant)
        print("navigate")
    }
    
    private func fetchRestaurants() {
        NetworkManager.shared.fetchRestaurants { [weak self] result in
            switch result {
            case .success(let restaurants):
                self?.restaurants = restaurants
                self?.delegate?.restaurantsFetched(restaurants)
            case .failure(let error):
                self?.delegate?.showError(error)
            }
        }
    }
}
