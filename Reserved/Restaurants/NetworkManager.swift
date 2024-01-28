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
    static let shared = NetworkManager()
    
    init() {}
    
    // MARK: - Fetch Movies
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
            } catch {
                completion(.failure(.decodingError))
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
