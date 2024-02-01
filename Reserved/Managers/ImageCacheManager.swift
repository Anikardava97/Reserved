//
//  ImageCacheManager.swift
//  Reserved
//
//  Created by Ani's Mac on 31.01.24.
//

import UIKit

final class ImageCacheManager {
    // MARK: - Shared Instance
    static let shared = ImageCacheManager()
    
    // MARK: - Private Init
    private init() {}

    // MARK: - Property
    private var imageCache = NSCache<NSString, UIImage>()

    // MARK: - Methods
    func getImage(for url: String) -> UIImage? {
        return imageCache.object(forKey: url as NSString)
    }

    func setImage(_ image: UIImage, for url: String) {
        imageCache.setObject(image, forKey: url as NSString)
    }
}
