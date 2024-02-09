//
//  CheckoutViewModel.swift
//  Reserved
//
//  Created by Ani's Mac on 09.02.24.
//

import Foundation

final class CheckoutViewModel {
    // MARK: - Properties
    var creditCardManager = CreditCardManager()
    let totalPrice: Double?
    
    init(totalPrice: Double?) {
        self.totalPrice = totalPrice
    }
    // MARK: - Methods

}
