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
    
    private let networkManager = NetworkManager()
    private let baseURL = "https://mocki.io/v1/31a554b3-685d-4863-aa6a-7f30877f5555"
    
    // MARK: - Methods
    func viewDidLoad() {
        fetchRestaurants()
    }
    
    func navigateToRestaurantDetails(with restaurant: Restaurant) {
        delegate?.navigateToRestaurantDetails(with: restaurant)
        print("navigate")
    }
    
    private func fetchRestaurants() {
        networkManager.fetch(from: baseURL) { [weak self] (result: Result<RestaurantResponse, NetworkError>) in
            switch result {
            case .success(let fetchedRestaurants):
                self?.restaurants = fetchedRestaurants.restaurants
                self?.delegate?.restaurantsFetched(fetchedRestaurants.restaurants)
            case .failure(let error):
                self?.delegate?.showError(error)
            }
        }
    }
}
