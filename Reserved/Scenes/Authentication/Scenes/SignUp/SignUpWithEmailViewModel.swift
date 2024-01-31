//
//  SignUpWithEmailViewModel.swift
//  Reserved
//
//  Created by Ani's Mac on 15.01.24.
//

import Foundation
import Firebase

@MainActor
final class SignUpWithEmailViewModel: ObservableObject {
    // MARK: - Properties
    @Published var email = ""
    @Published var password = ""
    
    @Published var isEmailValid = false
    @Published var isPasswordMinimumLengthMet = false
    @Published var isPasswordUniqueCharacterMet = false
    
    @Published var showAlert = false
    @Published var alertMessage = ""
    
    // MARK: - Methods
    func signUp() {
        guard isAuthenticationValid else {
            showAlert = true
            return
        }
        Task {
            do {
                let _ = try await AuthenticationManager.shared.createUser(email: email, password: password)
                NavigationManager.shared.presentTabBarController()
            } catch { print("Error: \(error.localizedDescription)") }
        }
    }
}

// MARK: - Sign Up Authentication Validation Conditions
extension SignUpWithEmailViewModel: AuthenticationValidationProtocol {
    var isAuthenticationValid: Bool {
        validatePassword()
        validateEmail()
        return isEmailValid && isPasswordMinimumLengthMet && isPasswordUniqueCharacterMet
    }
    
    func validateEmail() {
        isEmailValid = email.contains("@")
    }
    
    func validatePassword() {
        isPasswordMinimumLengthMet = password.count >= 8
        isPasswordUniqueCharacterMet = password.rangeOfCharacter(from: CharacterSet(charactersIn: "!@#$%^&*(),.?\":{}|<>]")) != nil
    }
}


