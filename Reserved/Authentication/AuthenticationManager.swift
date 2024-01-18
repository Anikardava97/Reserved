//
//  AuthenticationManager.swift
//  Reserved
//
//  Created by Ani's Mac on 16.01.24.
//

import Foundation
import FirebaseAuth

protocol AuthenticationValidationProtocol {
    var isAuthenticationValid: Bool { get }
}

final class AuthenticationManager {
    // MARK: - Properties
    static let shared = AuthenticationManager()
    
    private init() { }
    
    // MARK: - Methods
    func getAuthenticatedUser() throws -> AuthorizationDataResultModel {
        guard let user = Auth.auth().currentUser else {
            throw URLError(.badServerResponse)
        }
        return AuthorizationDataResultModel(user: user)
    }
    
    func signOut() throws {
        try Auth.auth().signOut()
    }
}

// MARK: - Sign In Email
extension AuthenticationManager {
    func createUser(email: String, password: String) async throws -> AuthorizationDataResultModel  {
        let authorizationDataResult = try await Auth.auth().createUser(withEmail: email, password: password)
        return AuthorizationDataResultModel(user: authorizationDataResult.user)
    }
    
    func loginUser(email: String, password: String) async throws -> AuthorizationDataResultModel {
        let authorizationDataResult = try await Auth.auth().signIn(withEmail: email, password: password)
        return AuthorizationDataResultModel(user: authorizationDataResult.user)
    }
}

// MARK: - Sign In SSO
extension AuthenticationManager {
    @discardableResult
    func signInWithGoogle(tokens: GoogleSignInResultModel) async throws -> AuthorizationDataResultModel {
        let credential = GoogleAuthProvider.credential(withIDToken: tokens.idToken, accessToken: tokens.accessToken)
        return try await signIn(credential: credential)
    }
    
    func signIn(credential: AuthCredential) async throws -> AuthorizationDataResultModel {
        let authorizationDataResult = try await Auth.auth().signIn(with: credential)
        return AuthorizationDataResultModel(user: authorizationDataResult.user)
    }
}
