//
//  LoginOptionsViewModel.swift
//  Reserved
//
//  Created by Ani's Mac on 17.01.24.
//

import Foundation
import Firebase

@MainActor
final class LoginOptionsViewModel: ObservableObject {
    // MARK: Methods
    func signInGoogle() async throws {
        let helper = SignInGoogleHelper()
        let tokens = try await helper.signIn()
        try await AuthenticationManager.shared.signInWithGoogle(tokens: tokens)
        if let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate {
            sceneDelegate.presentTabBarController()
        }
    }
}


