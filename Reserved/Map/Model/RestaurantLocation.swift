//
//  Locations.swift
//  Reserved
//
//  Created by Ani's Mac on 27.01.24.
//

import Foundation
import MapKit
import CoreLocation

struct LocationResponse: Decodable {
    let locations: [RestaurantLocation]
}

struct RestaurantLocation: Decodable, Identifiable, Equatable {
    let id: Int
    let name: String
    let coordinates: CLLocationCoordinate2D
    let description: String
    let imageNames: [String]
    
    static func == (lhs: RestaurantLocation, rhs: RestaurantLocation) -> Bool {
        lhs.id == rhs.id
    }
    
    private enum CodingKeys: String, CodingKey {
        case id, name, description, imageNames, coordinates
    }
    
    private enum CoordinatesKeys: String, CodingKey {
        case latitude, longitude
    }
    
    // MARK: - Init
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Int.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        description = try container.decode(String.self, forKey: .description)
        imageNames = try container.decode([String].self, forKey: .imageNames)
        
        let coordinatesContainer = try container.nestedContainer(keyedBy: CoordinatesKeys.self, forKey: .coordinates)
        let latitude = try coordinatesContainer.decode(Double.self, forKey: .latitude)
        let longitude = try coordinatesContainer.decode(Double.self, forKey: .longitude)
        coordinates = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
}
