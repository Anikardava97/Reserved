//
//  LocationsListView.swift
//  Reserved
//
//  Created by Ani's Mac on 27.01.24.
//

import SwiftUI

struct LocationsListView: View {
    @ObservedObject var viewModel: LocationsViewModel
    
    var body: some View {
        List {
            ForEach(viewModel.locations, id: \.id) { location in
                Button {
                    viewModel.showNextLocation(location: location)
                } label: {
                    listRowView(location: location)
                }
                .padding(.vertical, 4)
                .listRowBackground(Color.clear)
            }
        }
        .listStyle(PlainListStyle())
    }
}

extension LocationsListView {
    private func listRowView(location: RestaurantLocation) -> some View {
        HStack(spacing: 12) {
            if let imageUrlString = location.imageNames.first, let url = URL(string: imageUrlString) {
                AsyncImage(url: url) { image in
                    image
                        .resizable()
                        .scaledToFill()
                } placeholder: {
                    ProgressView()
                }
                .frame(width: 64, height: 64)
                .cornerRadius(10)
            }
            
            VStack {
                Text(location.name)
                    .font(.headline)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}


