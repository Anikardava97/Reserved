//
//  ReservationViewModel.swift
//  Reserved
//
//  Created by Ani's Mac on 01.02.24.
//

import Foundation

final class ReservationViewModel {
    // MARK: - Properties
    var selectedRestaurant: Restaurant?
    var guestCount: Int = 2
    var selectedDate: Date?
    var selectedTime: String?
    
    // MARK: - Computed Properties
    var restaurantName: String {
        return selectedRestaurant?.name.uppercased() ?? ""
    }
    
    var restaurantImageURL: String? {
        return selectedRestaurant?.mainImageURL ?? ""
    }
    
    var formattedRestaurantName: String {
        let formattedName = restaurantName.map { String($0) }.joined(separator: " ")
        return formattedName
    }
    
    var formattedSelectedDate: String? {
        guard let selectedDate = selectedDate else {
            return nil
        }
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long
        return dateFormatter.string(from: selectedDate)
    }
    
    var formattedSelectedTime: String? {
        return selectedTime
    }
    
    var formattedGuestCount: Int {
        return guestCount
    }
    
    // MARK: - Init
    init(selectedRestaurant: Restaurant) {
        self.selectedRestaurant = selectedRestaurant
    }
    
    // MARK: - Methods
    func setSelectedDate(_ date: Date) {
        selectedDate = date
    }
    
    func setSelectedTime(_ time: String) {
        selectedTime = time
    }
    
    func incrementGuestCount() {
        if guestCount < 12 {
            guestCount += 1
        }
    }
    
    func decrementGuestCount() {
        if guestCount > 1 {
            guestCount -= 1
        }
    }
    
    func validateReservation(selectedDate: Date?, selectedTimeText: String?, selectedGuests: Int?, reservations: [Reservation]?) -> ValidationResult {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "HH:mm:ss"
        
        guard let selectedDate, let selectedTimeText, let selectedGuests, let reservations else { return .failure }
        
        let formattedDate = dateFormatter.string(from: selectedDate)
        let formattedTime = timeFormatter.string(from: timeFormatter.date(from: selectedTimeText + ":00") ?? Date())
        
        let reservedTables = reservations.filter { reservation in
            return reservation.date == formattedDate 
            && reservation.time == formattedTime
            && reservation.guestCount == selectedGuests
        }
        
        if reservedTables.count >= 2 {
            return .failure
        } else {
            return .success
        }
    }
}

enum ValidationResult {
    case success
    case failure
}

