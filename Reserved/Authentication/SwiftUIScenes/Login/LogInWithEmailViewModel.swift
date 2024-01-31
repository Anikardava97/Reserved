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
    @Published var showAlert = false
    
    // MARK: - Methods
    func logIn() {
        guard isAuthenticationValid else {
            showAlert = true
            return
        }
        
        Task {
            do {
                let _ = try await AuthenticationManager.shared.signInWithEmail(email: email, password: password)

                NavigationManager.shared.presentTabBarController()
                
            } catch {
                print("Error: \(error.localizedDescription)")
            }
        }
    }
}

// MARK: - Log In Authentication Validation Conditions
extension LogInWithEmailViewModel: AuthenticationValidationProtocol {
    var isAuthenticationValid: Bool {
        !email.isEmpty 
        && email.contains("@")
        && !password.isEmpty 
        && password.count > 7
    }
}
