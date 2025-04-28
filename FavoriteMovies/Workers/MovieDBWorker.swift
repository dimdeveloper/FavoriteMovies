//
//  MovieDBWorker.swift
//  FavoriteMovies
//
//  Created by Dmytro Melnyk on 26.04.2025.
//

import Foundation

class MovieDBWorker {
    
    var coreDataStore: LocalDataBase
    
    init(coreDataStore: LocalDataBase) {
      self.coreDataStore = coreDataStore
    }
    
    func saveMovies(_ movies: [MovieResponceModel]) {
        coreDataStore.saveMovies(movies)
    }
    
    func saveImage(_ image: ImageData) {
        coreDataStore.saveImage(image)
    }
    
    func fetchDBMovies(request: MovieList.FetchMovies.Request, completion: (MovieList.FetchMovies.Response?) -> ()) {
        let dbMovies = coreDataStore.fetchMovies(page: request.page)
        if !dbMovies.isEmpty {
            let responce = MovieList.FetchMovies.Response(movies: dbMovies)
            completion(responce)
        } else {
            completion(nil)
        }  
    }

    func fetchMovie(movieID: String, completion: SingleMovieCompletionHandler) {
        if let result = coreDataStore.fetchMovie(movieID: movieID) {
            completion(.success(result))
        } else {
            completion(.failure(.generalError))
        }
    }
    
    func fetchImage(imageURL: String, completion: (Data)-> ()) {
        if let imageData = coreDataStore.fetchImage(imageURL: imageURL) {
            completion(imageData)
        }
    }
    
    func updateMovie(movie: MovieResponceModel) {
        coreDataStore.updateMovie(with: movie)
    }
    
    func updateImage(image: ImageData) {
        coreDataStore.updateImage(image: image)
    }
}
