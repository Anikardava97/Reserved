//
//  SignUpWithEmailView.swift
//  Reserved
//
//  Created by Ani's Mac on 15.01.24.
//

import SwiftUI

struct SignUpWithEmailView: View {
    @StateObject private var viewModel = SignUpWithEmailViewModel()

    // MARK: - Body
    var body: some View {
        ZStack {
            Color.customBackgroundColor.ignoresSafeArea()
            contentView
        } 
    }
    
    // MARK: - Content
    private var contentView: some View {
        VStack(spacing: 48) {
            titleView
            emailAndPasswordTextFieldsView
            signUpAndLoginButtons
            Spacer()
        }
    }
    
    private var titleView: some View {
        AppBenefitTextComponentView(
            text: "Become a Reserved member",
            height: 24,
            fontWeight: .bold)
        .padding(.top, 48)
    }
    
    private var emailAndPasswordTextFieldsView: some View {
        VStack(spacing: 20) {
            EmailTextField(email: $viewModel.email)
            PasswordTextField(password: $viewModel.password)
        }
    }
    
    private var signUpAndLoginButtons: some View {
        VStack(spacing: 20) {
            PrimaryButtonComponentView(text: "Sign up", textColor: .black, backgroundColor: .white)
            SecondaryButtonComponentView(text: "Log in", textColor: .white, strokeColor: .white)
        }
    }
}

#Preview {
    SignUpWithEmailView()
}
