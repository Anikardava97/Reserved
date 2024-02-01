//
//  NetworkManager.swift
//  Reserved
//
//  Created by Ani's Mac on 19.01.24.
//

import UIKit

enum NetworkError: Error {
    case invalidURL
    case noData
    case decodingError
    case other(Error)
}

final class NetworkManager {
    // MARK: - Shared Instance
    static let shared = NetworkManager()
    
    // MARK: - Private Init
    private init() {}
    
    // MARK: - Fetch Restaurants
    public func fetch<T: Decodable>(from urlString: String, completion: @escaping (Result<T, NetworkError>) -> Void) {
        guard let url = URL(string: urlString) else {
            completion(.failure(.invalidURL))
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(.other(error)))
                return
            }
            
            guard let data = data else {
                completion(.failure(.noData))
                return
            }
            
            do {
                let decodedData = try JSONDecoder().decode(T.self, from: data)
                DispatchQueue.main.async{
                    completion(.success(decodedData))
                }
            } catch { completion(.failure(.decodingError)) }
        }.resume()
    }
    
    // MARK: - Download Image
    func downloadImage(from urlString: String, completion: @escaping (UIImage?) -> Void) {
        if let cachedImage = ImageCacheManager.shared.getImage(for: urlString) {
            completion(cachedImage)
            return
        }
        
        guard let url = URL(string: urlString) else {
            completion(nil)
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, let downloadedImage = UIImage(data: data) else {
                completion(nil)
                return
            }
            ImageCacheManager.shared.setImage(downloadedImage, for: urlString)
            completion(downloadedImage)
        }
        task.resume()
    }
}


