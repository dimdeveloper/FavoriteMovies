//
//  MovieDetailsIterator.swift
//  FavoriteMovies
//
//  Created by MyMacbook on 27.04.2025.
//

import Foundation

class MovieDetailsInteractor {
    private let apiWorker = MovieAPIWorker(networkManager: NetworkManager.shared)
    private let dbWorker = MovieDBWorker(coreDataStore: CoreDataService())
    
    var presenter: MovieDetailsPresenter?
    
    func fetchMovieDetails(request: MovieDetails.FetchMovie.Request) {
        apiWorker.fetchMovie(id: request.movieID) { responce in
            switch responce {
            case .success(let movie):
                let responce = MovieDetails.FetchMovie.Response(movie: movie)
                
                if let path = movie.backdropPath {
                    self.fetchMovieImage(from: path)
                }
                
                self.presenter?.presentMovie(response: responce)
                self.dbWorker.saveMovies([movie])
            case .failure(let error):
                print("Network failed! Fetching from Core Data...")
                self.fetchMovieFromLocalDatabase(movieID: request.movieID)
            }
        }
    }
    
    func fetchMovieImage(from imagePath: String) {
        apiWorker.loadImage(pathURL: imagePath) { result in
            if let result {
                self.presenter?.presentMovieImage(imageData: result)
            } else {
                //self.presenter?.presentError(error)
            }
        }
    }
    
    func fetchMovieFromLocalDatabase(movieID: String) {
        apiWorker.fetchMovie(id: movieID) { result in
            switch result {
            case .success(let movie):
                self.presenter?.presentMovieDetails(movie)
            case .failure(let error):
                self.presenter?.presentError(error.localizedDescription)
            }
        }
    }
}
