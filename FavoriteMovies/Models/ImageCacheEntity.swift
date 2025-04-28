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
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<ImageCacheEntity> {
        return NSFetchRequest<ImageCacheEntity>(entityName: "ImageCacheEntity")
    }
    
    @NSManaged public var url: String?
    @NSManaged public var data: Data?
}

@objc(ImageSetEntity)
class ImageSetEntity: NSManagedObject {
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<ImageSetEntity> {
        return NSFetchRequest<ImageSetEntity>(entityName: "ImageSetEntity")
    }
    
    @NSManaged var images: Set<ImageCacheEntity>?
}

extension ImageSetEntity {
    func addImage(_ movie: ImageCacheEntity) {
        self.mutableSetValue(forKey: "images").add(movie)
    }
}
