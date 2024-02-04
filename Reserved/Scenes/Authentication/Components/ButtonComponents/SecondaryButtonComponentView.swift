//
//  SecondaryButtonComponentView.swift
//  Reserved
//
//  Created by Ani's Mac on 15.01.24.
//

import SwiftUI

struct SecondaryButtonComponentView: View {
    // MARK: - Properties
    var text: String
    var textColor: Color
    var strokeColor: Color
    var icon: Image?
    var iconColor: Color?
    var iconSize: Int?
    
    // MARK: - Body
    var body: some View {
        ZStack {
            Text(text)
                .foregroundStyle(textColor)
                .font(.system(size: 16, weight: .medium))
                .frame(maxWidth: .infinity, maxHeight: 48, alignment: .center)
            
            if let icon, let iconSize {
                HStack {
                    icon
                        .resizable()
                        .scaledToFit()
                        .foregroundStyle(iconColor ?? .primary)
                        .frame(width: CGFloat(iconSize), height: CGFloat(iconSize))
                        .padding(.leading, 20)
                    Spacer()
                }
            }
        }
        .frame(height: 48)
        .overlay(
            RoundedRectangle(cornerRadius: 6)
                .stroke(strokeColor, lineWidth: 1)
        )
        .padding(.horizontal, 16)
    }
}

