//
//  EmailTextField.swift
//  Reserved
//
//  Created by Ani's Mac on 15.01.24.
//

import SwiftUI

struct EmailTextField: View {
    //MARK: - Properties
    @Binding var email: String
    
    //MARK: - Body
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Email address")
                .foregroundStyle(.white)
                .font(.system(size: 14, weight: .medium))
            
            TextField("", text: $email, prompt: Text("Enter your email address")
                .font(.system(size: 12))
                .foregroundStyle(.white.opacity(0.5))
            )
            .padding(.horizontal, 16)
            .frame(height: 48)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(
                RoundedRectangle(cornerRadius: 6)
                    .stroke(Color.white.opacity(0.5), lineWidth: 1.0))
        }
        .padding(.horizontal, 16)
    }
}
