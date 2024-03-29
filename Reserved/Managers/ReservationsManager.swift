//
//  ReservationsManager.swift
//  Reserved
//
//  Created by Ani's Mac on 29.01.24.
//

import UIKit
import FirebaseAuth

final class ReservationManager {
    // MARK: - Shared Instance
    static let shared = ReservationManager()
    
    // MARK: - Private Init
    private init() {}
    
    // MARK: - Properties
    var myReservations: [MyReservation] = []
    
    // MARK: - Methods
    func storeReservation(
        restaurantName: String,
        reservationDate: String,
        reservationTime: String,
        guestsCount: Int,
        foodItems: [FoodItem]? = nil,
        gift: FoodItem? = nil
    ) {
        if let index = myReservations.firstIndex(where: {
            $0.restaurantName == restaurantName &&
            $0.reservationDate == reservationDate &&
            $0.reservationTime == reservationTime
        }) {
            var reservationToUpdate = myReservations[index]
            reservationToUpdate.guestsCount = guestsCount
            reservationToUpdate.foodItems = foodItems
            reservationToUpdate.gift = gift
            myReservations[index] = reservationToUpdate
        } else {
            let newReservation = MyReservation(
                restaurantName: restaurantName,
                reservationDate: reservationDate,
                reservationTime: reservationTime,
                guestsCount: guestsCount,
                foodItems: foodItems,
                gift: gift)
            myReservations.append(newReservation)
        }
        saveReservationsForCurrentUser()
    }
    
    func cancelReservation(atIndex index: Int) {
        guard index >= 0 && index < myReservations.count else { return }
        myReservations.remove(at: index)
        saveReservationsForCurrentUser()
    }
    
    func getAllReservations() -> [MyReservation] {
        return myReservations
    }
    
    private func updateBadgeCounts() {
        DispatchQueue.main.async {
            guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return }
            guard let tabBarController = windowScene.windows.first(where: { $0.isKeyWindow })?.rootViewController as? TabBarController else { return }
            tabBarController.updateBadgeCounts()
        }
    }
}

// MARK: - Extension: Save and Load Reservations
extension ReservationManager {
    func saveReservationsForCurrentUser() {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        let key = UserDefaults.standard.keyForUserSpecificData(base: "myReservations", userId: userId)
        do {
            let data = try JSONEncoder().encode(myReservations)
            UserDefaults.standard.set(data, forKey: key)
            updateBadgeCounts()
        } catch {
            print("Error saving reservations for user \(userId): \(error)")
        }
    }
    
    func loadReservationsForCurrentUser() {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        let key = UserDefaults.standard.keyForUserSpecificData(base: "myReservations", userId: userId)
        guard let data = UserDefaults.standard.data(forKey: key) else { return }
        if let reservations = try? JSONDecoder().decode([MyReservation].self, from: data) {
            self.myReservations = reservations
            updateBadgeCounts()
        } else {
            print("Failed to decode reservations for user \(userId).")
        }
    }
}
