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
    let dayFormatter: DateFormatter = {
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
    
     func isRestaurantOpen(from restaurant: Restaurant) -> Bool {
        let day = currentDayOfWeek()
        let openHours = restaurant.openHours
        let now = Date()
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "h:mm a"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        
        var startTime: String = ""
        var endTime: String = ""
        
        switch day {
        case "monday":
            startTime = openHours.monday.startTime.rawValue
            endTime = openHours.monday.endTime.rawValue
            
        case "tuesday":
            startTime = openHours.tuesday.startTime.rawValue
            endTime = openHours.tuesday.endTime.rawValue
            
        case "wednesday":
            startTime = openHours.wednesday.startTime.rawValue
            endTime = openHours.wednesday.endTime.rawValue
            
        case "thursday":
            startTime = openHours.thursday.startTime.rawValue
            endTime = openHours.thursday.endTime.rawValue
            
        case "friday":
            startTime = openHours.friday.startTime.rawValue
            endTime = openHours.friday.endTime.rawValue
            
        case "saturday":
            startTime = openHours.saturday.startTime.rawValue
            endTime = openHours.saturday.endTime.rawValue
            
        case "sunday":
            startTime = openHours.sunday.startTime.rawValue
            endTime = openHours.sunday.endTime.rawValue
            
        default:
            return false
        }
        
        return isNowBetween(startTime: startTime, endTime: endTime, currentDate: now, dateFormatter: dateFormatter)
    }
    
     func isNowBetween(startTime: String, endTime: String, currentDate: Date, dateFormatter: DateFormatter) -> Bool {
        guard let start = dateFormatter.date(from: startTime),
              let end = dateFormatter.date(from: endTime) else { return false }
        
        var adjustedEndTime = end
        if end < start {
            adjustedEndTime = Calendar.current.date(byAdding: .day, value: 1, to: end)!
        }
        
        let calendar = Calendar.current
        let startDateTimeComponents = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: start)
        let adjustedEndDateTimeComponents = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: adjustedEndTime)
        
        let startDateTime = calendar.date(bySettingHour: startDateTimeComponents.hour!, minute: startDateTimeComponents.minute!, second: 0, of: currentDate)!
        let adjustedEndDateTime = calendar.date(bySettingHour: adjustedEndDateTimeComponents.hour!, minute: adjustedEndDateTimeComponents.minute!, second: 0, of: currentDate)!
        
        return currentDate >= startDateTime && currentDate <= adjustedEndDateTime
    }
}
