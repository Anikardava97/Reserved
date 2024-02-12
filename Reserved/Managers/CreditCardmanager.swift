//
//  CreditCardmanager.swift
//  Reserved
//
//  Created by Ani's Mac on 09.02.24.
//

import Foundation
import FirebaseAuth

final class CreditCardManager {
    // MARK: - Shared Instance
    static let shared = CreditCardManager()
    
    // MARK: - Properties
    var cards: [CreditCard]
    var balance: Double
    
    // MARK: - Init
    init(initialBalance: Double = 100) {
        self.balance = initialBalance
        self.cards = []
        loadCardsForCurrentUser()
    }
    
    // MARK: - Methods
    func addCard(_ card: CreditCard) {
        cards.append(card)
        saveCardsForCurrentUser()
    }
    
    func removeCard(at index: Int) {
        guard index >= 0, index < cards.count else { return }
        cards.remove(at: index)
        saveCardsForCurrentUser()
    }
}

// MARK: - Extension: Save and Load Cards
extension CreditCardManager {
    func saveCardsForCurrentUser() {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        let key = UserDefaults.standard.keyForUserSpecificData(base: "myCards", userId: userId)
        do {
            let data = try JSONEncoder().encode(cards)
            UserDefaults.standard.set(data, forKey: key)
        } catch {
            print("Error saving cards for user \(userId): \(error)")
        }
    }
    
    func loadCardsForCurrentUser() {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        let key = UserDefaults.standard.keyForUserSpecificData(base: "myCards", userId: userId)
        guard let data = UserDefaults.standard.data(forKey: key) else {
            return }
        if let cards = try? JSONDecoder().decode([CreditCard].self, from: data) {
            self.cards = cards
        } else {
            print("Failed to decode cards for user \(userId).")
        }
    }
}
