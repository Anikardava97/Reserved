//
//  ReservationsManager.swift
//  Reserved
//
//  Created by Ani's Mac on 29.01.24.
//

import Foundation

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
    func storeReservation(restaurantName: String, reservationDate: String, reservationTime: String, guestsCount: Int) {
        let newReservation = MyReservation(
            restaurantName: restaurantName,
            reservationDate: reservationDate,
            reservationTime: reservationTime,
            guestsCount: guestsCount
        )
        myReservations.append(newReservation)
        delegate?.reservationManagerDidUpdateReservations()
    }
    
    func cancelReservation(restaurantName: String, reservationDate: String, reservationTime: String, guestsCount: Int) {
        myReservations.removeAll {
            $0.restaurantName == restaurantName &&
            $0.reservationDate == reservationDate &&
            $0.reservationTime == reservationTime &&
            $0.guestsCount == guestsCount
        }
        delegate?.reservationManagerDidUpdateReservations()
    }
    
    func getAllReservations() -> [MyReservation] {
        return myReservations
    }
}
