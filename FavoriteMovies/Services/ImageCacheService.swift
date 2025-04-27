//
//  ImageCacheService.swift
//  FavoriteMovies
//
//  Created by Dmytro Melnyk on 27.04.2025.
//

import Foundation
import UIKit

class ImageCache {
    static let shared = ImageCache()

    private let cache = NSCache<NSString, UIImage>()

    func getImage(for url: URL) -> UIImage? {
        return cache.object(forKey: url.absoluteString as NSString)
    }

    func saveImage(_ image: UIImage, for url: URL) {
        cache.setObject(image, forKey: url.absoluteString as NSString)
    }
}
