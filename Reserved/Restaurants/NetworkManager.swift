//
//  NetworkManager.swift
//  Reserved
//
//  Created by Ani's Mac on 19.01.24.
//

import UIKit

final class NetworkManager {
    static let shared = NetworkManager()
    private let baseURL = "https://mocki.io/v1/eddb6fbd-1ab7-4daf-a758-95b7410b3359"
    
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
        guard let url = URL(string: "https://img.itinari.com/page/content/original/9517d133-96b2-46f1-8c71-0736fe0731c9-stampa-hotel-cafe-interior-design-m-08-r.jpg?ch=DPR&dpr=2.625&w=994&s=23a3a6a4030bf98d74a9806886946098") else {
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

