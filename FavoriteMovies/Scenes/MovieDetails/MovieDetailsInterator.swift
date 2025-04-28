//
//  MovieDetailsIterator.swift
//  FavoriteMovies
//
//  Created by Dmytro Melnyk on 27.04.2025.
//

import Foundation
import UIKit

protocol MovieDetailsLogic {
    func fetchMovieDetails(request: MovieDetails.FetchMovie.Request)
}

class MovieDetailsInteractor: MovieDetailsLogic {
    private let apiWorker = MovieAPIWorker(networkManager: NetworkManager.shared)
    private let dbWorker = MovieDBWorker(coreDataStore: CoreDataService.shared)
    
    var presenter: MovieDetailsPresenterLogic?
    
    func fetchMovieDetails(request: MovieDetails.FetchMovie.Request) {
        apiWorker.fetchMovie(id: request.movieID) { responce in
            switch responce {
            case .success(let movie):
                let responce = MovieDetails.FetchMovie.Response(movie: movie)
                
                self.fetchMovieImage(from: movie.backdropPath)
                
                self.presenter?.presentMovie(response: responce)
                self.dbWorker.updateMovie(movie: movie)
            case .failure(_):
                self.fetchMovieFromLocalDatabase(movieID: request.movieID)
            }
        }
    }
}

// MARK: Private extensions
private extension MovieDetailsInteractor {
    
    func fetchDBImage(imagePath: String?) {
        guard let imagePath else { return }
        self.dbWorker.fetchImage(imageURL: imagePath) { data in
            self.presenter?.presentMovieImage(imageData: data)
        }
    }
    
    func fetchMovieFromLocalDatabase(movieID: String) {
        dbWorker.fetchMovie(movieID: movieID) { result in
            switch result {
            case .success(let movie):
                let responce = MovieDetails.FetchMovie.Response(movie: movie)
                DispatchQueue.main.async {
                    self.presenter?.presentMovie(response: responce)
                }
                fetchDBImage(imagePath: movie.backdropPath)
            case .failure(_):
                break
            }
        }
    }
    
    func fetchMovieImage(from imagePath: String?) {
        guard let imagePath else { return }
        apiWorker.loadImage(pathURL: imagePath) { result in
            guard let result else { return }
            self.presenter?.presentMovieImage(imageData: result)
            self.dbWorker.updateImage(image: ImageData(url: imagePath, imagedata: result))
        }
    }
}

