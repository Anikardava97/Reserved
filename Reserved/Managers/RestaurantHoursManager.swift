//
//  RestaurantHoursManager.swift
//  Reserved
//
//  Created by Ani's Mac on 20.01.24.
//

import Foundation

final class RestaurantHoursManager {
    // MARK: - Shared Instance
    static let shared = RestaurantHoursManager()
    
    // MARK: - Private Init
    private init() {}
    
    // MARK: - Properties
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "h:mm a"
        return formatter
    }()
    
    private let dayFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE"
        return formatter
    }()
    
    // MARK: - Methods
    func currentDayOfWeek() -> String {
        return dayFormatter.string(from: Date()).lowercased()
    }
    
    func getTodaysOpeningHours(from restaurant: Restaurant) -> String {
        let day = currentDayOfWeek()
        let openHours = getHoursForDay(for: day, from: restaurant.openHours)
        
        guard let hours = openHours else { return "Closed" }
        return "\(hours.startTime.rawValue) - \(hours.endTime.rawValue)"
    }
    
    func isRestaurantOpen(from restaurant: Restaurant) -> Bool {
        let day = currentDayOfWeek()
        guard let openHours = getHoursForDay(for: day, from: restaurant.openHours) else { return false }
        
        let now = Date()
        guard let startTime = dateFormatter.date(from: openHours.startTime.rawValue),
              let endTime = dateFormatter.date(from: openHours.endTime.rawValue) else { return false }
        
        let adjustedEndTime = endTime < startTime ? Calendar.current.date(byAdding: .day, value: 1, to: endTime)! : endTime
        
        return now >= startTime && now <= adjustedEndTime
    }
    
    func getHoursForDay(for day: String, from openHours: OpenHours) -> Day? {
        switch day {
        case "monday": return openHours.monday
        case "tuesday": return openHours.tuesday
        case "wednesday": return openHours.wednesday
        case "thursday": return openHours.thursday
        case "friday": return openHours.friday
        case "saturday": return openHours.saturday
        case "sunday": return openHours.sunday
        default: return nil
        }
    }
}
