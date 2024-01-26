//
//  NetworkManager.swift
//  Reserved
//
//  Created by Ani's Mac on 19.01.24.
//

import UIKit

final class NetworkManager {
    static let shared = NetworkManager()
    private let baseURL = "https://mocki.io/v1/07efd3e0-3cf5-4f91-8ea9-533c5c64bb78"
    
    private init() {}
    
    // MARK: - Fetch Movies
    func fetchRestaurants(completion: @escaping (Result<[Restaurant], Error>) -> Void) {
        let urlStr = baseURL
        
        guard let url = URL(string: urlStr) else {
            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])))
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "", code: -2, userInfo: [NSLocalizedDescriptionKey: "No data received"])))
                return
            }
            
            do {
                let restaurantsResponse = try JSONDecoder().decode(RestaurantResponse.self, from: data)
                completion(.success(restaurantsResponse.restaurants))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
    
    // MARK: - Download Image
    func downloadImage(from urlString: String, completion: @escaping (UIImage?) -> Void) {
        guard let url = URL(string: urlString) else {
            completion(nil)
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil, let image = UIImage(data: data) else {
                completion(nil)
                return
            }
            
            completion(image)
        }.resume()
    }
}
