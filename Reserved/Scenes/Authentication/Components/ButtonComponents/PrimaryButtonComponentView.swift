//
//  PrimaryButtonComponentView.swift
//  Reserved
//
//  Created by Ani's Mac on 15.01.24.
//

import SwiftUI

struct PrimaryButtonComponentView: View {
    //MARK: - Properties
    var text: String
    var textColor: Color
    var backgroundColor: Color
    
    //MARK: - Body
    var body: some View {
        Text(text.capitalized)
            .foregroundStyle(textColor)
            .font(.system(size: 16, weight: .bold))
            .frame(maxWidth: .infinity)
            .frame(height: 48)
            .background(backgroundColor)
            .cornerRadius(6)
            .padding(.horizontal, 16)
    }
}

