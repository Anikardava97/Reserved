//
//  LocationPreviewView.swift
//  Reserved
//
//  Created by Ani's Mac on 28.01.24.
//

import SwiftUI

struct LocationPreviewView: View {
    // MARK: - Properties
    let location: RestaurantLocation
    @ObservedObject var viewModel: LocationsViewModel
    
    // MARK: - Body
    var body: some View {
        // MARK: - Body
        HStack(alignment: .bottom, spacing: 0) {
            VStack(spacing: 8) {
                imageSection
                titleSection
            }
            
            Spacer()
            
            VStack(spacing: 8) {
                learnMoreButton
                nextButton
            }
        }
        .padding(20)
        .padding(.top, 20)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(.ultraThinMaterial)
                .offset(y: 70)
        )
        .cornerRadius(12)
    }
}

extension LocationPreviewView {
    private var imageSection: some View {
        ZStack {
            if let imageUrlString = location.imageNames.first, let url = URL(string: imageUrlString) {
                AsyncImage(url: url) { image in
                    image
                        .resizable()
                        .scaledToFill()
                } placeholder: {
                    ProgressView()
                }
                
                .frame(width: 140, height: 140)
                .cornerRadius(70)
            }
        }
    }
    
    private var titleSection: some View {
        Text(location.name)
            .font(.title2)
            .fontWeight(.bold)
    }
    
    private var learnMoreButton: some View {
        Button {
            viewModel.sheetLocation = location
        } label: {
            Text("Learn more")
                .font(.headline)
                .frame(width: 125, height: 44)
        }
        .buttonStyle(.borderedProminent)
        .tint(Color.customAccentColor)
    }
    
    private var nextButton: some View {
        Button {
            viewModel.nextButtonDidTap()
        } label: {
            Text("Next")
                .font(.headline)
                .frame(width: 125, height: 44)
        }
        .buttonStyle(.bordered)
        .foregroundStyle(Color.white)
    }
}
