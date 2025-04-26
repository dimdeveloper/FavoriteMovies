//
//  MovieEntity.swift
//  FavoriteMovies
//
//  Created by Dmytro Melnyk on 26.04.2025.
//

import Foundation
import CoreData

class MovieEntity: NSManagedObject {
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<MovieEntity>
    {
        return NSFetchRequest<MovieEntity>(entityName: "MovieEntity")
    }

    @NSManaged public var id: String?
    @NSManaged public var overview: String?
    @NSManaged public var title: String?
    @NSManaged public var posterImage: Data?
    @NSManaged public var backdropImage: Data?
    @NSManaged public var value: NSNumber?
    @NSManaged public var releaseDate: String?
    
    var voteAverage: Double {
        get { value?.doubleValue ?? 0.0 }
        set { value = NSNumber(value: newValue) }
    }
}
