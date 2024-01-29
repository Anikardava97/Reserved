//
//  ReservationsManager.swift
//  Reserved
//
//  Created by Ani's Mac on 29.01.24.
//

import Foundation

final class ReservationManager {
    static let shared = ReservationManager()
    private init() {}

    var myReservations: [MyReservation] = []

    func storeReservation(restaurantName: String, reservationDate: String, reservationTime: String, guestsCount: Int) {
        let newReservation = MyReservation(
            restaurantName: restaurantName,
            reservationDate: reservationDate,
            reservationTime: reservationTime,
            guestsCount: guestsCount
        )
        myReservations.append(newReservation)
    }
    
    func cancelReservation(restaurantName: String, reservationDate: String, reservationTime: String, guestsCount: Int) {
        myReservations.removeAll {
            $0.restaurantName == restaurantName &&
            $0.reservationDate == reservationDate &&
            $0.reservationTime == reservationTime &&
            $0.guestsCount == guestsCount
        }
    }

    func getAllReservations() -> [MyReservation] {
        return myReservations
    }
}
