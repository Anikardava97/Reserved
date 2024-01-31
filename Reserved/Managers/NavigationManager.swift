//
//  NavigationManager.swift
//  Reserved
//
//  Created by Ani's Mac on 31.01.24.
//

import UIKit
import SwiftUI

final class NavigationManager {
    // MARK: - Shared Instance
    static let shared = NavigationManager()
    
    // MARK: - Window
    private var window: UIWindow?
    
    // MARK: - Private Init
    private init() {}
    
    // MARK: - Methods
    func setUpWindow(for windowScene: UIWindowScene) {
        let window = UIWindow(windowScene: windowScene)
        let rootView = LaunchScreenView { self.showRootView(in: window) }
        let hostingController = UIHostingController(rootView: rootView)
        window.rootViewController = UINavigationController(rootViewController: hostingController)
        window.makeKeyAndVisible()
        self.window = window
    }
    
    func showRootView(in window: UIWindow) {
        let rootViewController = UIHostingController(rootView: LoginOptionsView(navigateToLoginView: navigateToLoginView))
        if let navigationController = window.rootViewController as? UINavigationController {
            navigationController.pushViewController(rootViewController, animated: true)
            setBackButtonTitle("Login Options")
        }
    }
    
    func navigateToLoginView() {
        let rootViewController = UIHostingController(rootView: LogInWithEmailView(navigateToSignUpView: navigateToSignUpView))
        if let navigationController = window?.rootViewController as? UINavigationController {
            navigationController.pushViewController(rootViewController, animated: true)
            setBackButtonTitle("Log In")
        }
    }
    
    func navigateToSignUpView() {
        let rootViewController = UIHostingController(rootView: SignUpWithEmailView(navigateToLoginView: navigateToLoginView))
        if let navigationController = window?.rootViewController as? UINavigationController {
            navigationController.pushViewController(rootViewController, animated: true)
            setBackButtonTitle("Sign In")
        }
    }
    
    func navigateToLaunchScreen() {
        guard let window = window else { return }
        let rootView = LaunchScreenView { self.showRootView(in: window) }
        let hostingController = UIHostingController(rootView: rootView)
        window.rootViewController = UINavigationController(rootViewController: hostingController)
    }
    
    func presentTabBarController() {
        let tabBarController = TabBarController()
        if let window = window {
            window.rootViewController = tabBarController
            window.makeKeyAndVisible()
        }
    }
    
    private func setBackButtonTitle(_ title: String) {
        let backButton = UIBarButtonItem(title: title, style: .plain, target: nil, action: nil)
        if let navigationController = window?.rootViewController as? UINavigationController {
            navigationController.topViewController?.navigationItem.backBarButtonItem = backButton
        }
    }
}
