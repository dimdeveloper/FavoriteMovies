//
//  MovieEntity.swift
//  FavoriteMovies
//
//  Created by Dmytro Melnyk on 26.04.2025.
//

import Foundation
import CoreData

@objc(MovieEntity)
public class MovieEntity: NSManagedObject {
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<MovieEntity>
    {
        return NSFetchRequest<MovieEntity>(entityName: "MovieEntity")
    }

    @NSManaged public var id: String?
    @NSManaged public var overview: String?
    @NSManaged public var title: String?
    @NSManaged public var posterImage: String?
    @NSManaged public var backdropImage: String?
    @NSManaged public var value: NSNumber?
    @NSManaged public var releaseDate: String?
    
    var voteAverage: Double {
        get { value?.doubleValue ?? 0.0 }
        set { value = NSNumber(value: newValue) }
    }
}

@objc(MovieListEntity)
public class MovieListEntity: NSManagedObject {
    @NSManaged public var movies: Set<MovieEntity>?
}

extension MovieListEntity {
    func addMovie(_ movie: MovieEntity) {
        self.mutableSetValue(forKey: "movies").add(movie)
    }
}
