//
//  ImageCacheEntity.swift
//  FavoriteMovies
//
//  Created by Dmytro Melnyk on 27.04.2025.
//

import Foundation
import CoreData

@objc(ImageCacheEntity)
class ImageCacheEntity: NSManagedObject {
    
    @nonobjc class func fetchRequest() -> NSFetchRequest<ImageCacheEntity> {
        return NSFetchRequest<ImageCacheEntity>(entityName: "ImageCacheEntity")
    }
    
    @NSManaged var url: String?
    @NSManaged var data: Data?
}

@objc(ImageSetEntity)
class ImageSetEntity: NSManagedObject {
    
    @nonobjc class func fetchRequest() -> NSFetchRequest<ImageSetEntity> {
        return NSFetchRequest<ImageSetEntity>(entityName: "ImageSetEntity")
    }
    
    @NSManaged var images: Set<ImageCacheEntity>?
}

extension ImageSetEntity {
    func addImage(_ movie: ImageCacheEntity) {
        self.mutableSetValue(forKey: "images").add(movie)
    }
}
