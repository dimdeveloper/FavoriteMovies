//
//  MovieListInteractor.swift
//  FavoriteMovies
//
//  Created by Dmytro Melnyk on 26.04.2025.
//

import Foundation
import UIKit

enum ImageType {
    case poster
    case backdrop
}

protocol MovieListDataStore {
    var movies: [Movie] { get }
}

protocol MovieListUseCases {
    func fetchMovies()
}

class MovieListInteractor: MovieListDataStore, MovieListUseCases {
    private let apiWorker = MovieAPIWorker(networkManager: NetworkManager.shared)
    private let dbWorker = MovieDBWorker(coreDataStore: CoreDataService())
    
    private var currentPage: Int = 1
    private var pagesCount: Int = 1
    var presenter: MovieListPresenter?
    var movies: [Movie] = []
    private var isFetching = false
    
    func fetchMovies() {
        guard !isFetching, currentPage <= pagesCount else { return }
        isFetching = true
        apiWorker.fetchMovies(currentPage: currentPage) { responce in
            self.isFetching = false
            switch responce {
            case .success(let moviesResponce):
                let fetchedResult = MovieList.FetchMovies.Response(movies: moviesResponce.results)
                self.currentPage += 1
                self.pagesCount = moviesResponce.totalPages
                self.presenter?.presentMovies(response: fetchedResult)
                self.dbWorker.saveMovies(moviesResponce.results)
            case .failure(let error):
                break
            }
        }
    }

    func fetchImage(for movie: MovieList.FetchMovies.ViewModel.MovieViewModel) {
        if let posterImagePath = movie.posterPath {
            fetchPosterImage(for: posterImagePath) {
                if let backdropImagePath = movie.backdropPath {
                    self.fetchBackdropImage(for: backdropImagePath)
                }
            }
        }
    }

    func fetchPosterImage(for path: String, completion: @escaping() -> ()) {
        if let url = URL(string: path), let cachedImage = ImageCache.shared.getImage(for: url) {
            completion()
            DispatchQueue.main.async {
                self.presenter?.updateImage(posterPath: path, image: cachedImage)
            }
        } else {
            apiWorker.loadImage(pathURL: path) { data in
                if let data {
                    if let image = UIImage(data: data), let url = URL(string: path) {
                        ImageCache.shared.saveImage(image, for: url)
                    }
                    DispatchQueue.main.async {
                        self.presenter?.updateImage(posterPath: path, imageData: data)
                    }
                    self.dbWorker.saveImage(ImageData(url: path, imagedata: data))
                    completion()
                } else {
                    completion()
                }
            }
        }
    }
        
    func fetchBackdropImage(for path: String) {
        apiWorker.loadImage(pathURL: path) { data in
            if let data {
                self.dbWorker.saveImage(ImageData(url: path, imagedata: data))
            } else {
               print("Error fetching image")
            }
        }
    }
}
