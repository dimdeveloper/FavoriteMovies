//
//  CoreDataService.swift
//  FavoriteMovies
//
//  Created by Dmytro Melnyk on 26.04.2025.
//

import Foundation

import CoreData
import UIKit

struct ImageData {
    var url: String
    var imagedata: Data
}

protocol LocalDataBase {
    func saveMovies(_ movies: [MovieResponceModel])
    func fetchMovies(page: Int) -> [MovieResponceModel]
    func saveImage(_ images: ImageData)
    func fetchMovie(movieID: String) -> MovieResponceModel?
    func updateMovie(with newMovie: MovieResponceModel)
    func updateImage(image: ImageData)
    func fetchImage(imageURL: String) -> Data?
}

class CoreDataService: LocalDataBase {
    static let shared = CoreDataService()
    private let context = PersistenceManager.shared.context

    func saveMovies(_ movies: [MovieResponceModel]) {
        let movieList = MovieListEntity(context: context)
        
        for (index, movie) in movies.enumerated() {
            guard let id = movie.id else { return }
            let fetchRequest: NSFetchRequest<MovieEntity> = MovieEntity.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "id == %@", String(id))
            
            let results = try? context.fetch(fetchRequest)
            
            if results?.first == nil {
                let entity = MovieEntity(context: context)
                entity.id = String(id)
                entity.title = movie.originalTitle
                entity.overview = movie.overview
                entity.releaseDate = movie.releaseDate
                entity.backdropImage = movie.backdropPath
                entity.posterImage = movie.posterPath
                entity.apiOrder = Int16(index)
                movieList.addMovie(entity)
            }
        }
        try? context.save()
    }
    
    func updateMovie(with newMovie: MovieResponceModel) {
        guard let id = newMovie.id else { return }
        let fetchRequest: NSFetchRequest<MovieEntity> = MovieEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", String(id))
        
        let results = try? context.fetch(fetchRequest)
        
        if let existingMovie = results?.first {
            context.delete(existingMovie)
        }
        
        saveMovies([newMovie])
    }

    func updateImage(image: ImageData) {
        let fetchRequest: NSFetchRequest<ImageSetEntity> = ImageSetEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "ANY images.url == %@", image.url)
        
        let results = try? context.fetch(fetchRequest)
        
        if let existingImage = results?.first {
            context.delete(existingImage)
        }
        
        saveImage(image)
    }

    func fetchMovies(page: Int) -> [MovieResponceModel] {
        let fetchRequest: NSFetchRequest<MovieEntity> = MovieEntity.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "apiOrder", ascending: true)]
        // make pagination behaviour
        fetchRequest.fetchLimit = 20
        fetchRequest.fetchOffset = page * 20
        
        do {
            let result = try context.fetch(fetchRequest)
            return result.map{ MovieEntity.from(entity: $0) }
        } catch {
            print("Core Data fetch failed: \(error)")
            return []
        }
    }
    
    func fetchMovie(movieID: String) -> MovieResponceModel? {
        let fetchRequest: NSFetchRequest<MovieEntity> = MovieEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", movieID)
        
        if let dbMovie = try? context.fetch(fetchRequest).first {
            return MovieEntity.from(entity: dbMovie)
        } else {
            return nil
        }
    }
    
    func saveImage(_ image: ImageData) {
        let imagesSet = ImageSetEntity(context: context)
        if !isImageCached(imageURL: image.url) {
            let imageEntity = ImageCacheEntity(context: context)
            imageEntity.url = image.url
            imageEntity.data = image.imagedata
            imagesSet.addImage(imageEntity)
            
            try? context.save()
        }
    }
    
    func fetchImage(imageURL: String) -> Data? {
        let fetchRequest: NSFetchRequest<ImageCacheEntity> = ImageCacheEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "url == %@", imageURL)
        
        if let dbImage = try? context.fetch(fetchRequest).first {
            return dbImage.data
        } else {
            return nil
        }
    }
    
    func isImageCached(imageURL: String) -> Bool {
        let fetchRequest: NSFetchRequest<ImageCacheEntity> = ImageCacheEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "url == %@", imageURL)
        fetchRequest.fetchLimit = 1

        do {
            let count = try context.count(for: fetchRequest)
            return count > 0
        } catch {
            print("Error checking cache: \(error)")
            return false
        }
    }
}
