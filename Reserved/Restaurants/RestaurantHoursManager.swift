//
//  RestaurantHoursManager.swift
//  Reserved
//
//  Created by Ani's Mac on 20.01.24.
//

import Foundation

final class RestaurantHoursManager {
    // MARK: - Methods
    static func currentDayOfWeek() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        return dateFormatter.string(from: Date()).lowercased()
    }
    
    static func getTodaysOpeningHours(from restaurant: Restaurant) -> String {
        let day = currentDayOfWeek()
        let openHours = restaurant.openHours
        
        switch day {
        case "monday":
            return "\(openHours.monday.startTime.rawValue) - \(openHours.monday.endTime.rawValue)"
            
        case "tuesday":
            return "\(openHours.tuesday.startTime.rawValue) - \(openHours.tuesday.endTime.rawValue)"
            
        case "wednesday":
            return "\(openHours.wednesday.startTime.rawValue) - \(openHours.wednesday.endTime.rawValue)"
            
        case "thursday":
            return "\(openHours.thursday.startTime.rawValue) - \(openHours.thursday.endTime.rawValue)"
            
        case "friday":
            return "\(openHours.friday.startTime.rawValue) - \(openHours.friday.endTime.rawValue)"
            
        case "saturday":
            return "\(openHours.saturday.startTime.rawValue) - \(openHours.saturday.endTime.rawValue)"
            
        case "sunday":
            return "\(openHours.sunday.startTime.rawValue) - \(openHours.sunday.endTime.rawValue)"
            
        default:
            return "Closed"
        }
    }
    
    static func isRestaurantOpen(from restaurant: Restaurant) -> Bool {
        let day = currentDayOfWeek()
        let openHours = restaurant.openHours
        let now = Date()
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "h:mm a"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        
        switch day {
        case "monday":
            return isNowBetween(startTime: openHours.monday.startTime.rawValue,
                                endTime: openHours.monday.endTime.rawValue,
                                currentDate: now,
                                dateFormatter: dateFormatter)
            
        case "tuesday":
            return isNowBetween(startTime: openHours.tuesday.startTime.rawValue,
                                endTime: openHours.tuesday.endTime.rawValue,
                                currentDate: now,
                                dateFormatter: dateFormatter)
            
        case "wednesday":
            return isNowBetween(startTime: openHours.wednesday.startTime.rawValue,
                                endTime: openHours.wednesday.endTime.rawValue,
                                currentDate: now,
                                dateFormatter: dateFormatter)
            
        case "thursday":
            return isNowBetween(startTime: openHours.thursday.startTime.rawValue,
                                endTime: openHours.thursday.endTime.rawValue,
                                currentDate: now,
                                dateFormatter: dateFormatter)
            
        case "friday":
            return isNowBetween(startTime: openHours.friday.startTime.rawValue,
                                endTime: openHours.friday.endTime.rawValue,
                                currentDate: now,
                                dateFormatter: dateFormatter)
            
        case "saturday":
            return isNowBetween(startTime: openHours.saturday.startTime.rawValue,
                                endTime: openHours.saturday.endTime.rawValue,
                                currentDate: now,
                                dateFormatter: dateFormatter)
            
        case "sunday":
            return isNowBetween(startTime: openHours.sunday.startTime.rawValue,
                                endTime: openHours.sunday.endTime.rawValue,
                                currentDate: now,
                                dateFormatter: dateFormatter)
        default:
            return false
        }
    }
    
    static func isNowBetween(startTime: String, endTime: String, currentDate: Date, dateFormatter: DateFormatter) -> Bool {
        guard let start = dateFormatter.date(from: startTime),
              let end = dateFormatter.date(from: endTime) else { return false }
        
        var adjustedEndTime = end
        if end < start {
            adjustedEndTime = Calendar.current.date(byAdding: .day, value: 1, to: end)!
        }
        
        let startDateTime = Calendar.current.startOfDay(for: currentDate) + start.timeIntervalSince1970
        let endDateTime = Calendar.current.startOfDay(for: currentDate) + adjustedEndTime.timeIntervalSince1970
        
        return currentDate >= startDateTime && currentDate <= endDateTime
    }
}

