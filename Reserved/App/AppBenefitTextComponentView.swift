//
//  AppBenefitTextComponentView.swift
//  Reserved
//
//  Created by Ani's Mac on 15.01.24.
//

import SwiftUI

struct AppBenefitTextComponentView: View {
    //MARK: - Properties
    var text: String
    var height: CGFloat
    var fontWeight: Font.Weight?

    //MARK: - Body
        var body: some View {
            HStack(spacing: 12) {
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color.customAccentColor)
                    .frame(width: 3)
                
                Text(text)
                    .frame(maxWidth: .infinity, alignment: .leading) 
                    .multilineTextAlignment(.leading)
                    .foregroundStyle(.white)
                    .font(.system(size: 16, weight: fontWeight))
                    .lineSpacing(8)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .frame(height: height)
            .padding(.horizontal, 16)
        }
    }

