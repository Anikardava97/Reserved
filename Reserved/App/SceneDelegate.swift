//
//  SceneDelegate.swift
//  Reserved
//
//  Created by Ani's Mac on 15.01.24.
//

import UIKit
import SwiftUI

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        setUpWindow(for: windowScene)
    }
    
    func setUpWindow(for windowScene: UIWindowScene) {
        window = UIWindow(windowScene: windowScene)
        let rootView = LaunchScreenView { self.showRootView() }
        let hostingController = UIHostingController(rootView: rootView)
        window?.rootViewController = UINavigationController(rootViewController: hostingController)
        window?.makeKeyAndVisible()
    }
    
    func showRootView() {
        let rootViewController = UIHostingController(rootView: LoginOptionsView(navigateToLoginView: navigateToLoginView))
        if let navigationController = self.window?.rootViewController as? UINavigationController {
            navigationController.pushViewController(rootViewController, animated: true)
            
            let backButton = UIBarButtonItem(title: "Log In Options", style: .plain, target: nil, action: nil)
            navigationController.topViewController?.navigationItem.backBarButtonItem = backButton
        }
    }
    
    func navigateToLoginView() {
        let rootViewController = UIHostingController(rootView: LogInWithEmailView(navigateToSignUpView: navigateToSignUpView))
        if let navigationController = self.window?.rootViewController as? UINavigationController {
            navigationController.pushViewController(rootViewController, animated: true)
            
            let backButton = UIBarButtonItem(title: "Log In", style: .plain, target: nil, action: nil)
            navigationController.topViewController?.navigationItem.backBarButtonItem = backButton
        }
    }
    
    func navigateToSignUpView() {
        let rootViewController = UIHostingController(rootView: SignUpWithEmailView(navigateToLoginView: navigateToLoginView))
        if let navigationController = self.window?.rootViewController as? UINavigationController {
            navigationController.pushViewController(rootViewController, animated: true)
            
            let backButton = UIBarButtonItem(title: "Sign In", style: .plain, target: nil, action: nil)
            navigationController.topViewController?.navigationItem.backBarButtonItem = backButton
        }
    }
    
    func presentTabBarController() {
        let tabBarController = TabBarController()
        if let window = self.window {
            window.rootViewController = tabBarController
            window.makeKeyAndVisible()
        }
    }
    
    func goBack() {
        if let navigationController = self.window?.rootViewController as? UINavigationController {
            navigationController.popViewController(animated: true)
        }
    }
        
        func sceneDidDisconnect(_ scene: UIScene) { }
        
        func sceneDidBecomeActive(_ scene: UIScene) { }
        
        func sceneWillResignActive(_ scene: UIScene) { }
        
        func sceneWillEnterForeground(_ scene: UIScene) { }
        
        func sceneDidEnterBackground(_ scene: UIScene) { }
        
    }
    
