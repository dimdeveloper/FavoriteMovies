//
//  CoreDataService.swift
//  FavoriteMovies
//
//  Created by Dmytro Melnyk on 26.04.2025.
//

import Foundation

import CoreData
import UIKit

class CoreDataService {
    static let shared = CoreDataService()
    private let context = PersistenceManager.shared.context

    func saveMovies(_ movies: [Movie]) {
        let movieList = MovieListEntity(context: context)
        
        movies.forEach { movie in
            let entity = MovieEntity(context: context)
            entity.id = movie.id
            entity.title = movie.title
            entity.overview = movie.overview
            entity.releaseDate = movie.releaseDate
            entity.backdropImage = movie.backdropData
            entity.posterImage = movie.posterData
            movieList.addMovie(entity)
        }
        try? context.save()
    }

    func fetchMovies() -> [Movie] {
        let request: NSFetchRequest<MovieEntity> = MovieEntity.fetchRequest()
        let entities = (try? context.fetch(request)) ?? []
        return entities.map { MovieEntity.from(entity: $0) }
    }
}
