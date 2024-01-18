//
//  SignUpWithEmailView.swift
//  Reserved
//
//  Created by Ani's Mac on 15.01.24.
//

import SwiftUI

struct SignUpWithEmailView: View {
    // MARK: - Properties
    @StateObject private var viewModel = SignUpWithEmailViewModel()
    
    var navigateToLoginView: () -> Void
    
    // MARK: - Body
    var body: some View {
        ZStack {
            Color.customBackgroundColor.ignoresSafeArea()
            contentView
        }
        .alert(isPresented: $viewModel.showAlert) {
            Alert(
                title: Text("Registration Error"),
                message: Text("Please enter a valid information."),
                dismissButton: .default(Text("OK"))
            )
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
        .padding(.top, 24)
    }
    
    private var emailAndPasswordTextFieldsView: some View {
        VStack(alignment: .leading, spacing: 20) {
            CustomTextFieldComponentView(text: $viewModel.email, title: "Email address", prompt: "Enter your email address", isSecure: false)
                .onChange(of: viewModel.email) {
                    viewModel.validateEmail()
                }
            
            CustomTextFieldComponentView(text: $viewModel.password, title: "Password", prompt: "Enter your password", isSecure: true)
                .onChange(of: viewModel.password) {
                    viewModel.validatePassword()
                }
            
            PasswordStrengthChecklist(
                isPasswordMinimumLengthMet: viewModel.isPasswordMinimumLengthMet,
                isPasswordUniqueCharacterMet: viewModel.isPasswordUniqueCharacterMet
            )
        }
    }
    
    private var signUpAndLoginButtons: some View {
        VStack(spacing: 20) {
            Button {
                viewModel.signUp()
            } label: {
                PrimaryButtonComponentView(text: "Sign up", textColor: .white, backgroundColor: Color.customAccentColor)
            }
            
            Button {
                navigateToLoginView()
            } label: {
                SecondaryButtonComponentView(text: "Log in", textColor: .white, strokeColor: .white)
            }
        }
    }
}

#Preview {
    SignUpWithEmailView { }
}
