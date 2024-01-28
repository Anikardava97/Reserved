//
//  LocationMapAnnotationView.swift
//  Reserved
//
//  Created by Ani's Mac on 28.01.24.
//

import SwiftUI

struct LocationMapAnnotationView: View {
    // MARK: - Body
    var body: some View {
        VStack(spacing: 0) {
            Image(systemName: "fork.knife.circle.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 30, height: 30)
                .font(.headline)
                .foregroundStyle(.white)
                .padding(6)
                .background(Color.customAccentColor)
                .cornerRadius(36)
            
            Image(systemName: "triangle.fill")
                .resizable()
                .scaledToFit()
                .foregroundStyle(Color.customAccentColor)
                .frame(width: 10, height: 10)
                .rotationEffect(Angle(degrees: 180))
                .offset(y: -3)
                .padding(.bottom, 40)
        }
    }
}

#Preview {
    LocationMapAnnotationView()
}
