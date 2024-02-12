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
    
    var formattedGuestCount: Int {
        return guestCount
    }
    
    // MARK: - Init
    init(selectedRestaurant: Restaurant) {
        self.selectedRestaurant = selectedRestaurant
    }
    
    // MARK: - Validate Result
    enum ValidationResult {
        case success
        case failure
    }
    
    // MARK: - Methods
    func setSelectedDate(_ date: Date) {
        selectedDate = date
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
            && reservation.time == formattedTime && reservation.guestCount == selectedGuests
        }
        
        if reservedTables.count >= 2 {
            return .failure
        } else {
            return .success
        }
    }
    
    func isValidTime(_ time: Date, for restaurant: Restaurant) -> Bool {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "h:mm a"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        
        let todayHours = RestaurantHoursManager.shared.getTodaysOpeningHours(from: restaurant)
        let hoursArray = todayHours.components(separatedBy: " - ")
        
        guard hoursArray.count == 2,
              let openTimeStr = hoursArray.first,
              let closeTimeStr = hoursArray.last,
              let openTime = dateFormatter.date(from: openTimeStr),
              let closeTime = dateFormatter.date(from: closeTimeStr) else {
            return false
        }
        let now = Date()
        let calendar = Calendar.current
        let openDateTime = calendar.date(bySettingHour: calendar.component(.hour, from: openTime),
                                         minute: calendar.component(.minute, from: openTime),
                                         second: 0,
                                         of: now)!
        
        var closeDateTime = calendar.date(bySettingHour: calendar.component(.hour, from: closeTime),
                                          minute: calendar.component(.minute, from: closeTime),
                                          second: 0,
                                          of: now)!
        if closeTime < openTime {
            closeDateTime = calendar.date(byAdding: .day, value: 1, to: closeDateTime)!
        }
        return time >= openDateTime && time <= closeDateTime
    }
}


