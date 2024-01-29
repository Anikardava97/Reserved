//
//  ReservationsViewController.swift
//  Reserved
//
//  Created by Ani's Mac on 18.01.24.
//

import UIKit

class ReservationsViewController: UIViewController {
    // MARK: - Properties
    let emptyStateViewController = EmptyStateViewController(
        title: "Start your culinary journey",
        description: "Your reservation history is empty. Start your journey by booking a table.",
        animationName: "Animation - 1706506120281")
    
    // MARK: - ViewLifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        showEmptyStateViewController()
    }
    
    // MARK: - Methods
    private func showEmptyStateViewController() {
        addChild(emptyStateViewController)
        view.addSubview(emptyStateViewController.view)
        emptyStateViewController.didMove(toParent: self)
    }
}

#Preview {
    ReservationsViewController()
}
