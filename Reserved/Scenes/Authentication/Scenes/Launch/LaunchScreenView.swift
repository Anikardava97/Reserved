//
//  LaunchScreenView.swift
//  Reserved
//
//  Created by Ani's Mac on 15.01.24.
//

import SwiftUI

struct LaunchScreenView: View {
    // MARK: - Properties
    @State private var animateGlasses = false
    @State private var animateText = false
    @State private var animateLogo = false
    
    var navigateToLoginOptionsView: () -> Void
    
    // MARK: - Body
    var body: some View {
        ZStack {
            Color.customBackgroundColor.ignoresSafeArea()
            contentView
        }
    }
    
    // MARK: - Content
    private var contentView: some View {
        VStack {
            Spacer()
            glassLeftSideImageView
            Spacer()
            welcomeTextAndLogoView
            Spacer()
            appBenefitTextView
            Spacer()
            getStartedButtonView
        }
    }
    
    private var glassLeftSideImageView: some View {
        HStack(spacing: 8) {
            Spacer()
            Image("glassLeft")
                .resizable()
                .scaledToFit()
                .frame(width: 105, height: 156)
                .offset(x: animateGlasses ? 4 : 0, y: animateGlasses ? -4 : 0)
            Image("glassRight")
                .resizable()
                .scaledToFit()
                .frame(width: 120, height: 130)
                .offset(x: animateGlasses ? -6 : 0, y: animateGlasses ? 4 : 0)
        }
        .onAppear {
            withAnimation(Animation.easeInOut(duration: 0.8).repeatForever(autoreverses: true)) {
                animateGlasses.toggle()
            }
        }
    }
    
    private var welcomeTextAndLogoView: some View {
        VStack(spacing: 10) {
            Text("Welcome to")
                .font(.system(size: 32))
                .foregroundStyle(.white)
                .offset(x: animateText ? 0 : -UIScreen.main.bounds.width)
                .onAppear {
                    withAnimation(Animation.easeInOut(duration: 1).delay(0.5)) {
                        animateText = true
                    }
                }
            Image.logoImage
                .resizable()
                .scaledToFit()
                .frame(width: 114, height: 38)
                .offset(x: animateLogo ? 0 : UIScreen.main.bounds.width)
                .onAppear {
                    withAnimation(Animation.easeInOut(duration: 1).delay(0.5)) {
                        animateLogo = true
                    }
                }
        }
    }
    
    private var appBenefitTextView: some View {
        VStack(alignment: .leading, spacing: 24) {
            AppBenefitTextComponentView(
                text: "Choose your favourite restaurant\nAnd book a table effortlessly",
                height: 48)
            AppBenefitTextComponentView(
                text: "Find and reserve tables at nearby \nRestaurants with ease",
                height: 48)
        }
    }
    
    private var getStartedButtonView: some View {
        Button {
            navigateToLoginOptionsView()
        } label: {
            PrimaryButtonComponentView(
                text: "Get Started",
                textColor: Color.white,
                backgroundColor: Color.customAccentColor)
        }
    }
}

