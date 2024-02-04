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
    
    // MARK: - Methods
    private func showAlert(
        from viewController: UIViewController,
        title: String,
        message: String,
        actions: [UIAlertAction] = [UIAlertAction(title: "OK", style: .default)]) {
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            actions.forEach { action in
                alert.addAction(action)
            }
            viewController.present(alert, animated: true)
        }
    
    func showInvalidTimeAlert(from viewController: UIViewController) {
        showAlert(from: viewController,
                  title: "Invalid Time 😳",
                  message: "The selected time is unavailable. The restaurant is closed at that time. Please choose a different time.")
    }
    
    func showNoAvailableTablesAlert(from viewController: UIViewController) {
        showAlert(
            from: viewController,
            title: "No Available Tables 😳",
            message: "There are no available tables for the selected date, time, and guest count. Please choose a different option👩🏻‍🍳")
    }
    
    func showLocationUnavailableAlert(from viewController: UIViewController) {
        showAlert(from: viewController, title: "Error", message: "Location information is not available")
    }
    
    func showUnavailableTableAlert(from viewController: UIViewController, for guests: Int) {
        showAlert(from: viewController, title: "Table Unavailable 😳", message: "This table is not available for \(guests) guests. Please choose a different table.")
    }
}
