//
//  OrderFoodViewModel.swift
//  Reserved
//
//  Created by Ani's Mac on 06.02.24.
//

import Foundation

protocol OrderFoodViewModelDelegate: AnyObject {
    func fetchedFood(_ foodItems: [FoodItem])
    func showError(_ receivedError: Error)
    func productsAmountChanged()
}

final class OrderFoodViewModel {
    weak var delegate: OrderFoodViewModelDelegate?

    var foodItems: [FoodItem]?
    var totalPrice: Double? { foodItems?.reduce(0) { $0 + $1.price * Double(($1.selectedAmount ?? 0))} }

    // MARK: - Methods
    func viewDidLoad() {
        fetchFoodItems()
    }
    
    private func fetchFoodItems() {
        NetworkManager.shared.fetch(from: "https://mocki.io/v1/4c8233b2-085c-4ae6-a031-c0ca5f665339") { [weak self] (result: Result<FoodResponse, NetworkError>) in
            switch result {
            case .success(let fetchedFood):
                self?.delegate?.fetchedFood(fetchedFood.foodItems)
            case .failure(let error):
                self?.delegate?.showError(error)
            }
        }
    }
    
    func addProduct(at index: Int) {
        guard let products = foodItems, index >= 0, index < products.count else { return }
        var product = products[index]
        product.selectedAmount = (product.selectedAmount ?? 0) + 1
        self.foodItems?[index] = product
        delegate?.productsAmountChanged()
    }
    
    func removeProduct(at index: Int) {
        guard let products = foodItems, index >= 0, index < products.count else { return }
        var product = products[index]
        guard let selectedAmount = product.selectedAmount, selectedAmount > 0 else { return }
        product.selectedAmount = selectedAmount - 1
        self.foodItems?[index] = product
        delegate?.productsAmountChanged()
    }
}
