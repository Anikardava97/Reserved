//
//  LocationsView.swift
//  Reserved
//
//  Created by Ani's Mac on 27.01.24.
//

import SwiftUI
import MapKit

struct LocationsView: View {
    @StateObject private var viewModel = LocationsViewModel()
    
    var body: some View {
        ZStack {
            mapLayer
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                header
                    .padding()
                Spacer()
                locationsPreviewStack
            }
        }
        .environment(\.colorScheme, .dark)
        .sheet(item: $viewModel.sheetLocation, onDismiss: nil, content: { location in
            LocationDetailsView(location: location, viewModel: viewModel)
        })
        .onAppear {
            viewModel.fetchRestaurantsLocations()
        }
    }
}

extension LocationsView {
    private var header: some View {
        VStack {
            Button {
                viewModel.toggleLocationsList()
            } label: {
                Text(viewModel.mapLocation?.name ?? "")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundStyle(.primary)
                    .frame(height: 55)
                    .frame(maxWidth: .infinity)
                    .animation(.none, value: viewModel.mapLocation)
                    .overlay(alignment: .leading) {
                        Image(systemName: "arrow.down")
                            .font(.headline)
                            .foregroundStyle(.primary)
                            .padding()
                            .rotationEffect(Angle(degrees: viewModel.showLocationsList ? 180 : 0))
                    }
            }
            .buttonStyle(.plain)
            
            if viewModel.showLocationsList {
                LocationsListView(viewModel: viewModel)
            }
        }
        .background(.thickMaterial)
        .cornerRadius(10)
        .shadow(color: .black.opacity(0.3), radius: 20, x: 0, y: 15)
    }
    
    private var mapLayer: some View {
        Map(position: $viewModel.cameraPosition) {
            ForEach(viewModel.locations, id: \.id) { location in
                Annotation("", coordinate: location.coordinates) {
                    LocationMapAnnotationView()
                        .scaleEffect(viewModel.mapLocation == location ? 1.0 : 0.7)
                        .shadow(radius: 10)
                        .onTapGesture {
                            viewModel.showNextLocation(location: location)
                        }
                }
            }
        }
    }
    
    private var locationsPreviewStack: some View {
        ZStack {
            ForEach(viewModel.locations, id: \.id) { location in
                if viewModel.mapLocation == location {
                    LocationPreviewView(location: location, viewModel: viewModel)
                        .shadow(color: .black.opacity(0.3), radius: 20)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .transition(.asymmetric(
                            insertion: .move(edge: .trailing),
                            removal: .move(edge: .leading)))
                }
            }
        }
    }
}

#Preview {
    LocationsView()
}


