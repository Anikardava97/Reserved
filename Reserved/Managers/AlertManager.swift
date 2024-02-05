//
//  AlertManager.swift
//  Reserved
//
//  Created by Ani's Mac on 04.02.24.
//

import UIKit

final class AlertManager {
    // MARK: - Shared Instance
    static let shared = AlertManager()
    
    // MARK: - Private Init
    private init() {}
    
    // MARK: - Alert Types
    enum AlertType {
        case invalidTime
        case noAvailableTables
        case locationUnavailable
        case unavailableTable(guests: Int)
    }
    
    // MARK: - Methods
    func showAlert(from viewController: UIViewController, type: AlertType) {
        let alert: UIAlertController
        
        switch type {
        case .invalidTime:
            alert = createAlert(title: "Invalid Time 😳", message: "The selected time is unavailable. The restaurant is closed at that time. Please choose a different time.")
        case .noAvailableTables:
            alert = createAlert(title: "No Available Tables 😳", message: "There are no available tables for the selected date, time, and guest count. Please choose a different option👩🏻‍🍳")
        case .locationUnavailable:
            alert = createAlert(title: "Error", message: "Location information is not available")
        case .unavailableTable(let guests):
            alert = createAlert(title: "Table Unavailable 😳", message: "This table is not available for \(guests) guests. Please choose a different table.")
        }
        viewController.present(alert, animated: true)
    }
    
    // MARK: - Private Methods
    private func createAlert(title: String, message: String) -> UIAlertController {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        return alert
    }
}
