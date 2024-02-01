//
//  TabBarController.swift
//  Reserved
//
//  Created by Ani's Mac on 18.01.24.
//

import UIKit
import SwiftUI

final class TabBarController: UITabBarController {
    // MARK: - ViewLifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabs()
        setupUI()
    }
    
    // MARK: - Tab Setup
    private func setupTabs() {
        let restaurants = createNavigationController(title: "Explore", image: UIImage(systemName: "fork.knife"), viewController: RestaurantsViewController())
        
        let locationsView = LocationsView()
        let mapHostingController = UIHostingController(rootView: locationsView)
        mapHostingController.tabBarItem = UITabBarItem(title: "Nearby", image: UIImage(systemName: "location"), selectedImage: nil)
        
        let reservations = createNavigationController(title: "Reservations", image: UIImage(systemName: "clock"), viewController: ReservationsHistoryViewController())
        if let reservationsViewController = reservations.viewControllers.first as? ReservationsHistoryViewController {
              ReservationManager.shared.delegate = reservationsViewController
          }
        
        let favourites = createNavigationController(title: "Favorites", image: UIImage(systemName: "heart"), viewController: FavoritesViewController())
        if let favouritesViewController = favourites.viewControllers.first as? FavoritesViewController {
               FavoritesManager.shared.delegate = favouritesViewController
           }
        
        let profile = createNavigationController(title: "Profile", image: UIImage(systemName: "person"), viewController: ProfileViewController())
        
        setViewControllers([restaurants, mapHostingController, reservations, favourites, profile], animated: true)
    }
    
    // MARK: - NavigationController Setup
    private func createNavigationController(title: String, image: UIImage?, viewController: UIViewController) -> UINavigationController {
        let navigationController = UINavigationController(rootViewController: viewController)
        navigationController.tabBarItem.title = title
        navigationController.tabBarItem.image = image
        navigationController.viewControllers.first?.navigationItem.title = title
        return navigationController
    }
    
    // MARK: - SetupUI
    private func setupUI() {
        tabBar.tintColor = UIColor.customAccentColor
        tabBar.unselectedItemTintColor = .white.withAlphaComponent(0.4)
        tabBar.standardAppearance = createTabBarAppearance()
        tabBar.scrollEdgeAppearance = createTabBarScrollEdgeAppearance()
    }
    
    private func createTabBarAppearance() -> UITabBarAppearance {
        let tabBarAppearance = UITabBarAppearance()
        tabBarAppearance.backgroundColor = UIColor.customBackgroundColor
        return tabBarAppearance
    }
    
    private func createTabBarScrollEdgeAppearance() -> UITabBarAppearance {
        let tabBarScrollEdgeAppearance = UITabBarAppearance()
        tabBarScrollEdgeAppearance.backgroundColor = UIColor.customBackgroundColor
        return tabBarScrollEdgeAppearance
    }
}
