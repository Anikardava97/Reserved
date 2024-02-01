//
//  LocationsViewModel.swift
//  Reserved
//
//  Created by Ani's Mac on 27.01.24.
//

import MapKit
import SwiftUI

final class LocationsViewModel: ObservableObject {
    // MARK: - Properties
    @Published var locations: [RestaurantLocation] = []
    @Published var cameraPosition = MapCameraPosition.region(MKCoordinateRegion())
    @Published var showLocationsList = false
    @Published var sheetLocation: RestaurantLocation? = nil
    @Published var mapLocation: RestaurantLocation? {
        didSet {
            if let location = mapLocation {
                updateMapRegion(location: location)
            }
        }
    }
    let mapSpan = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
    private let baseURL = "https://mocki.io/v1/980db280-b83b-4799-93d9-3e4ef34ee78a"
    
    
    // MARK: - Methods
    func fetchRestaurantsLocations() {
        NetworkManager.shared.fetch(from: baseURL) { [weak self] (result: Result<LocationResponse, NetworkError>) in
            switch result {
            case .success(let fetchedLocations):
                self?.locations = fetchedLocations.locations
                if let firstLocation = fetchedLocations.locations.first {
                    self?.mapLocation = firstLocation
                    self?.updateMapRegion(location: firstLocation)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func updateMapRegion(location: RestaurantLocation) {
        withAnimation(.easeInOut) {
            let newRegion = MKCoordinateRegion(center: location.coordinates, span: mapSpan)
            cameraPosition = .region(newRegion)
        }
    }
    
    func toggleLocationsList() {
        withAnimation(.easeInOut) {
            showLocationsList.toggle()
        }
    }
    
    func showNextLocation(location: RestaurantLocation) {
        withAnimation(.easeInOut) {
            mapLocation = location
            showLocationsList = false
        }
    }
    
    func nextButtonDidTap() {
        guard let currentIndex = locations.firstIndex(where: { $0 == mapLocation }) else {
            return
        }
        let nextIndex = currentIndex + 1
        guard locations.indices.contains(nextIndex) else {
            guard let firstLocation = locations.first else { return }
            showNextLocation(location: firstLocation)
            return
        }
        
        let nextLocation = locations[nextIndex]
        showNextLocation(location: nextLocation)
    }
}
