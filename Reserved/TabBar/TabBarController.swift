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
        mapHostingController.tabBarItem = UITabBarItem(title: "Nearby", image: UIImage(systemName: "map.fill"), selectedImage: nil)
        
        let reservations = createNavigationController(title: "Reservations", image: UIImage(systemName: "clock.fill"), viewController: ReservationsHistoryViewController())
        
        let favourites = createNavigationController(title: "Favorites", image: UIImage(systemName: "heart.fill"), viewController: FavoritesViewController())
        
        let profile = createNavigationController(title: "Profile", image: UIImage(systemName: "person.fill"), viewController: ProfileViewController())
        
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
        tabBar.unselectedItemTintColor = .white
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
    
    // MARK: - Update Badge Count
    func updateBadgeCounts() {
        let reservationsCount = ReservationManager.shared.myReservations.count
        let favoritesCount = FavoritesManager.shared.favoriteRestaurants.count
        
        DispatchQueue.main.async { [weak self] in
            self?.viewControllers?[2].tabBarItem.badgeValue = reservationsCount > 0 ? "\(reservationsCount)" : nil
            self?.viewControllers?[3].tabBarItem.badgeValue = favoritesCount > 0 ? "\(favoritesCount)" : nil
        }
    }
}
