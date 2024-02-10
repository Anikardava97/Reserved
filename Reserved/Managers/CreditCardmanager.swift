//
//  CreditCardmanager.swift
//  Reserved
//
//  Created by Ani's Mac on 09.02.24.
//

import Foundation

final class CreditCardManager {
    // MARK: - Properties
    var balance: Double
    var cards: [CreditCard]

    // MARK: - Init
    init(initialBalance: Double = 100) {
        self.balance = initialBalance
        self.cards = []
    }

    // MARK: - Methods
    func addCard(_ card: CreditCard) {
        cards.append(card)
    }

    func removeCard(at index: Int) {
        guard index >= 0, index < cards.count else { return }
        cards.remove(at: index)
    }

    func displayBalance() {
        print("Current Balance: $\(balance)")
    }

    func displayCards() {
        print("Cards:")
        for (index, card) in cards.enumerated() {
            print("\(index + 1). \(card.name) - \(card.number) - Expires: \(card.expirationDate)")
        }
    }
}
