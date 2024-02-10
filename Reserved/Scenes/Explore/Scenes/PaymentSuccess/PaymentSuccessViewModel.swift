//
//  PaymentSuccessViewModel.swift
//  Reserved
//
//  Created by Ani's Mac on 10.02.24.
//

import Foundation

protocol PaymentSuccessViewModelDelegate: AnyObject {
    func fetchedFood(_ foodItems: [FoodItem])
    func showError(_ receivedError: Error)
}

final class PaymentSuccessViewModel {
    // MARK: - Properties
    private let baseURL = Constants.URLs.restaurantFoodItemsURL
    weak var delegate: PaymentSuccessViewModelDelegate?
    
    var foodItems: [FoodItem]?

    // MARK: - Methods
    func fetchFoodItems(for restaurant: Restaurant) {
        let restaurantURL = baseURL + "?restaurantId=\(restaurant.id)"
        
        NetworkManager.shared.fetch(from: restaurantURL) { [weak self] (result: Result<FoodResponse, NetworkError>) in
            switch result {
            case .success(let fetchedFood):
                self?.delegate?.fetchedFood(fetchedFood.foodItems)
            case .failure(let error):
                self?.delegate?.showError(error)
            }
        }
    }
}
