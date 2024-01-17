//
//  LogInWithEmailViewModel.swift
//  Reserved
//
//  Created by Ani's Mac on 16.01.24.
//

import Foundation
import Firebase
 
@MainActor
final class LogInWithEmailViewModel: ObservableObject {
    // MARK: - Properties
    @Published var email = ""
    @Published var password = ""
    @Published var isEmailValid = true
    @Published var isPasswordValid = true
    @Published var showAlert = false
    
    var validationErrorMessage: String {
            if !isEmailValid {
                return "email address ✉️"
            } else if !isPasswordValid {
                return "password 🔐"
            } else {
                return ""
            }
        }

    // MARK: - Methods
    func logIn() {
        // TODO: - handle state when user taps button with no input
        guard isAuthenticationValid else {
            showAlert = true
            return
        }
        
        Task {
            do {
                let returnedUserData = try await AuthenticationManager.shared.loginUser(email: email, password: password)
                print("Success")
                print(returnedUserData)
            } catch {
                print("Error: \(error.localizedDescription)")
            }
        }
    }
    
    func validateInput() {
           isEmailValid = !email.isEmpty && email.contains("@")
           isPasswordValid = !password.isEmpty && password.count > 7
       }
}

extension LogInWithEmailViewModel: AuthenticationValidationProtocol {
    var isAuthenticationValid: Bool {
        validateInput()
        return isEmailValid && isPasswordValid
    }
}
