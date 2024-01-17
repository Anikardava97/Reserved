//
//  SignUpWithEmailViewModel.swift
//  Reserved
//
//  Created by Ani's Mac on 15.01.24.
//

import Foundation


final class SignUpWithEmailViewModel: ObservableObject {
    // MARK: - Properties
    @Published var email = ""
    @Published var password = ""
    
    // MARK: - Methods
    func signUp() {
        // TODO: - handle state when user taps button with no input
        guard !email.isEmpty, !password.isEmpty else { print("No email of password found")
            return
        }
        
        Task {
            do {
                let returnedUserData = try await AuthenticationManager.shared.createUser(email: email, password: password)
                print("Success")
                print(returnedUserData)
            } catch {
                print("Error: \(error.localizedDescription)")
            }
        }
    }
}
