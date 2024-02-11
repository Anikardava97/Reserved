//
//  ReservationsManager.swift
//  Reserved
//
//  Created by Ani's Mac on 29.01.24.
//

import Foundation
import FirebaseAuth

protocol ReservationManagerDelegate: AnyObject {
    func reservationManagerDidUpdateReservations()
}

final class ReservationManager {
    // MARK: - Shared Instance
    static let shared = ReservationManager()
    
    // MARK: - Private Init
    private init() {}
    
    // MARK: - Properties
    var myReservations: [MyReservation] = []
    weak var delegate: ReservationManagerDelegate?
    
    // MARK: - Methods
    func storeReservation(restaurantName: String, reservationDate: String, reservationTime: String, guestsCount: Int, foodItems: [FoodItem]? = nil, gift: FoodItem? = nil) {
        if let index = myReservations.firstIndex(where: { $0.restaurantName == restaurantName && $0.reservationDate == reservationDate && $0.reservationTime == reservationTime }) {
            var reservationToUpdate = myReservations[index]
            reservationToUpdate.guestsCount = guestsCount
            reservationToUpdate.foodItems = foodItems
            reservationToUpdate.gift = gift
            myReservations[index] = reservationToUpdate
        } else {
            let newReservation = MyReservation(restaurantName: restaurantName, reservationDate: reservationDate, reservationTime: reservationTime, guestsCount: guestsCount, foodItems: foodItems, gift: gift)
            myReservations.append(newReservation)
        }
        saveReservationsForCurrentUser()
        delegate?.reservationManagerDidUpdateReservations()
    }
    
    func cancelReservation(atIndex index: Int) {
        guard index >= 0 && index < myReservations.count else {
            print("Invalid reservation index.")
            return
        }
        
        myReservations.remove(at: index)
        delegate?.reservationManagerDidUpdateReservations()
        saveReservationsForCurrentUser()
    }
    
    func getAllReservations() -> [MyReservation] {
        return myReservations
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
        } else {
            print("Failed to decode reservations for user \(userId).")
        }
    }
}
