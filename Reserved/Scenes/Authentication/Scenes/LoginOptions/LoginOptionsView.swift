//
//  LoginOptionsView.swift
//  Reserved
//
//  Created by Ani's Mac on 15.01.24.
//

import SwiftUI

struct LoginOptionsView: View {
    // MARK: - Properties
    @StateObject private var viewModel = LoginOptionsViewModel()
    
    var navigateToLoginView: () -> Void
    
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
            loginButtons
            Spacer()
        }
    }
    
    private var titleView: some View {
        VStack(alignment: .leading, spacing: 32) {
            AppBenefitTextComponentView(
                text: "Your Culinary Journey Begins",
                height: 24,
                fontWeight: .bold)
            
            Text("Log in to start reserving\nTables")
                .font(.system(size: 24, weight: .bold))
                .lineSpacing(8)
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 16)
        }
        .padding(.top, 24)
    }
    
    private var loginButtons: some View {
        VStack(spacing: 16) {
            appleLoginView
            googleLoginView
            emailLoginView
        }
    }
    
    private var appleLoginView: some View {
        SecondaryButtonComponentView(
            text: "Continue with Apple",
            textColor: .white,
            strokeColor: .white,
            icon: Image(systemName: "apple.logo"),
            iconColor: .white,
            iconSize: 20)
    }
    
    private var googleLoginView: some View {
        Button {
            Task {
                do {
                    try await viewModel.signInGoogle()
                } catch {
                    print(error)
                }
            }
        } label: {
            SecondaryButtonComponentView(
                text: "Continue with Google",
                textColor: .white,
                strokeColor: .white,
                icon: Image("Google"),
                iconSize: 18)
        }
    }
    
    private var emailLoginView: some View {
        Button {
            navigateToLoginView()
        } label: {
            SecondaryButtonComponentView(
                text: "Continue with Email",
                textColor: .white,
                strokeColor: .white,
                icon: Image(systemName: "envelope"),
                iconColor: .white,
                iconSize: 20)
        }
    }
}
