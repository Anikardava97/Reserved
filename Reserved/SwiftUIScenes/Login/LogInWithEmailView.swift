//
//  LogInWithEmailView.swift
//  Reserved
//
//  Created by Ani's Mac on 16.01.24.
//

import SwiftUI

struct LogInWithEmailView: View {
    // MARK: - Properties
    @StateObject private var viewModel = LogInWithEmailViewModel()
    
    var navigateToSignUpView: () -> Void
    
    // MARK: - Body
    var body: some View {
        ZStack {
            Color.customBackgroundColor.ignoresSafeArea()
            contentView
        }
        .alert(isPresented: $viewModel.showAlert) {
            Alert(
                title: Text("Login Error"),
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
            text: "Welcome Back",
            height: 24,
            fontWeight: .bold)
        .padding(.top, 24)
    }
    
    private var emailAndPasswordTextFieldsView: some View {
        VStack(spacing: 20) {
            CustomTextFieldComponentView(text: $viewModel.email, title: "Email address", prompt: "Enter your email address", isSecure: false)
            CustomTextFieldComponentView(text: $viewModel.password, title: "Password", prompt: "Enter your password", isSecure: true)
        }
    }
    
    private var signUpAndLoginButtons: some View {
        VStack(spacing: 20) {
            Button {
                viewModel.logIn()
            } label: {
                PrimaryButtonComponentView(text: "Log In", textColor: .white, backgroundColor: Color.customAccentColor)
            }
            
            Button {
                navigateToSignUpView()
            } label: {
                SecondaryButtonComponentView(text: "Sign Up", textColor: .white, strokeColor: .white)
            }
        }
    }
}


#Preview {
    LogInWithEmailView { }
}
