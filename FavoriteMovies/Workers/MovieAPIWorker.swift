//
//  MovieAPIWorker.swift
//  FavoriteMovies
//
//  Created by Dmytro Melnyk on 26.04.2025.
//

import Foundation

protocol MovieAPIWorkerProtocol {
    func loadMoviesData(queryItem: URLQueryItem, completion: @escaping CompletionHandler)
    func loadImageData(imagePath: String, completion: @escaping (Data?) -> Void)
    func loadSingleMovieData(movieID: String, completion: @escaping SingleMovieCompletionHandler)
}

class MovieAPIWorker {
    var networkManager: MovieAPIWorkerProtocol
    
    init(networkManager: MovieAPIWorkerProtocol) {
      self.networkManager = networkManager
    }
    
    func fetchMovies(request: MovieList.FetchMovies.Request, completion: @escaping CompletionHandler) {
        let pageQuery = URLQueryItem(name: "page", value: String(request.page))
        networkManager.loadMoviesData(queryItem: pageQuery) { responce in
            completion(responce)
        }
    }
    
    func fetchMovie(id: String, completion: @escaping SingleMovieCompletionHandler) {
        networkManager.loadSingleMovieData(movieID: id) { responce in
            completion(responce)
        }
    }
    
    func loadImage(pathURL: String?, completion: @escaping (Data?) -> Void) {
        guard let path = pathURL else {
            completion(nil)
            return
        }
        networkManager.loadImageData(imagePath: path) { data in
            completion(data)
        }
    }
}
