//
//  ImageCacheEntity.swift
//  FavoriteMovies
//
//  Created by MyMacbook on 27.04.2025.
//

import Foundation
import CoreData

@objc(ImageCacheEntity)
class ImageCacheEntity: NSManagedObject {
    @NSManaged public var url: String?
    @NSManaged public var data: Data?
}

@objc(ImageSetEntity)
class ImageSetEntity: NSManagedObject {
    @NSManaged var images: Set<ImageCacheEntity>?
}

extension ImageSetEntity {
    func addImage(_ movie: ImageCacheEntity) {
        self.mutableSetValue(forKey: "images").add(movie)
    }
}
