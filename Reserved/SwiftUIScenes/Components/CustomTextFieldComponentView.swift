//
//  CustomTextFieldComponentView.swift
//  Reserved
//
//  Created by Ani's Mac on 16.01.24.
//

import SwiftUI

struct CustomTextFieldComponentView: View {
    // MARK: - Properties
    @Binding var text: String
    var title: String
    var prompt: String
    var isSecure: Bool
    
    // MARK: - Body
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .foregroundStyle(.white)
                .font(.system(size: 14, weight: .medium))
            
            Group {
                if isSecure {
                    SecureField("", text: $text, prompt: Text(text)
                        .font(.system(size: 12))
                        .foregroundStyle(.white.opacity(0.5))
                    )
                } else {
                    TextField("", text: $text, prompt: Text(text)
                        .font(.system(size: 12))
                        .foregroundStyle(.white.opacity(0.5))
                    )
                }
            }
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

