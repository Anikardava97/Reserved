//
//  SignInGoogleHelper.swift
//  Reserved
//
//  Created by Ani's Mac on 17.01.24.
//

import Foundation
import GoogleSignIn
import GoogleSignInSwift

final class SignInGoogleHelper {
    @MainActor
    // MARK: - Methods
    func signIn() async throws -> GoogleSignInResultModel {
        guard let topViewController = Utilities.shared.topViewController() else { throw URLError(.cannotFindHost) }
        
        let googleSignInResult = try await GIDSignIn.sharedInstance.signIn(withPresenting: topViewController)
        
        guard let idToken = googleSignInResult.user.idToken?.tokenString else {
            throw URLError(.badServerResponse)
        }
        let accessToken = googleSignInResult.user.accessToken.tokenString
        let tokens = GoogleSignInResultModel(idToken: idToken, accessToken:  accessToken)
        return tokens
    }
}
