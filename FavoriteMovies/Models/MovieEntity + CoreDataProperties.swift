//
//  MovieEntity.swift
//  FavoriteMovies
//
//  Created by Dmytro Melnyk on 26.04.2025.
//

import Foundation
import CoreData

@objc(MovieEntity)
class MovieEntity: NSManagedObject {
    
    @nonobjc class func fetchRequest() -> NSFetchRequest<MovieEntity> {
        return NSFetchRequest<MovieEntity>(entityName: "MovieEntity")
    }

    @NSManaged var id: String?
    @NSManaged var overview: String?
    @NSManaged var title: String?
    @NSManaged var posterImage: String?
    @NSManaged var backdropImage: String?
    @NSManaged var value: NSNumber?
    @NSManaged var releaseDate: String?
    @NSManaged var apiOrder: Int16
    
    var voteAverage: Double {
        get { value?.doubleValue ?? 0.0 }
        set { value = NSNumber(value: newValue) }
    }
}

@objc(MovieListEntity)
class MovieListEntity: NSManagedObject {
    @NSManaged public var movies: Set<MovieEntity>?
}

extension MovieListEntity {
    func addMovie(_ movie: MovieEntity) {
        self.mutableSetValue(forKey: "movies").add(movie)
    }
}
