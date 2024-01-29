//
//  LocationDetailsView.swift
//  Reserved
//
//  Created by Ani's Mac on 28.01.24.
//

import SwiftUI
import MapKit

struct LocationDetailsView: View {
    // MARK: - Properties
    @ObservedObject var viewModel: LocationsViewModel
    let location: RestaurantLocation
    
    // MARK: - Body
    var body: some View {
        ScrollView {
            VStack {
                imageSectionView
                    .shadow(color: .black.opacity(0.3), radius: 20, x: 0, y: 10)
                
                VStack(alignment: .leading, spacing: 0) {
                    titleView
                    Divider()
                    descriptionView
                    mapLayer
                }
            }
        }
        .ignoresSafeArea()
        .background(.ultraThickMaterial)
        .overlay(backButton, alignment: .topTrailing)
    }
}

// MARK: - Extensions
extension LocationDetailsView {
    private var imageSectionView: some View {
        TabView {
            ForEach(location.imageNames, id: \.self) { imageUrlString in
                if let url = URL(string: imageUrlString) {
                    AsyncImage(url: url) { image in
                        image
                            .resizable()
                            .scaledToFill()
                            .frame(width: UIScreen.main.bounds.width, height: 400)
                            .clipped()
                    } placeholder: {
                        ProgressView()
                            .frame(width: UIScreen.main.bounds.width, height: 400)
                    }
                }
            }
        }
        .frame(height: 400)
        .tabViewStyle(PageTabViewStyle())
    }
    
    private var titleView: some View {
        Text(location.name)
            .font(.largeTitle)
            .fontWeight(.semibold)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding()
    }
    
    private var descriptionView: some View {
        Text(location.description)
            .font(.subheadline)
            .foregroundStyle(.secondary)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding()
    }
    
    private var mapLayer: some View {
        Map(position: .constant(viewModel.cameraPosition)) {
            ForEach([location], id: \.id) { location in
                Annotation("", coordinate: location.coordinates) {
                    LocationMapAnnotationView()
                        .shadow(radius: 10)
                }
            }
        }
        .allowsHitTesting(false)
        .aspectRatio(1, contentMode: .fit)
        .cornerRadius(30)
    }
    
    private var backButton: some View {
        Button {
            viewModel.sheetLocation = nil
        } label: {
            Image(systemName: "xmark")
                .font(.headline)
                .padding(8)
                .foregroundStyle(Color.white)
                .background(Color.customAccentColor)
                .cornerRadius(10)
                .shadow(radius: 4)
                .padding()
        }
    }
}
