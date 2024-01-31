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
        NavigationManager.shared.setUpWindow(for: windowScene)
    }
}
