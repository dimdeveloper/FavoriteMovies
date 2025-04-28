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

protocol MovieListLogic {
    func fetchMovies()
    func fetchImage(for movie: MovieListViewModel)
}

class MovieListInteractor: MovieListLogic {
    private let apiWorker = MovieAPIWorker(networkManager: NetworkManager.shared)
    private let dbWorker = MovieDBWorker(coreDataStore: CoreDataService.shared)
    
    private var currentPage: Int = 1
    private var pagesCount: Int = 1
    var presenter: MovieListPresenterLogic?

    private var isFetching = false
    
    func fetchMovies() {
        guard !isFetching, currentPage <= pagesCount else { return }
        isFetching = true
        let request = MovieList.FetchMovies.Request(page: currentPage)
        apiWorker.fetchMovies(request: request) { responce in
            self.isFetching = false
            switch responce {
            case .success(let moviesResponce):
                let fetchedResult = MovieList.FetchMovies.Response(movies: moviesResponce.results)
                self.currentPage += 1
                self.pagesCount = moviesResponce.totalPages
                self.presenter?.presentMovies(response: fetchedResult)
                self.dbWorker.saveMovies(moviesResponce.results)
            case .failure(_):
                self.fecthDBMovies(request: request)
            }
        }
    }

    func fetchImage(for movie: MovieListViewModel) {
        if let posterImagePath = movie.posterPath {
            fetchPosterImage(for: posterImagePath) {
                if let backdropImagePath = movie.backdropPath {
                    // fetching backdropImages after fecthing posterImage asynchronously
                    self.fetchBackdropImage(for: backdropImagePath)
                }
            }
        }
    }
}

func fetchPosterImage(for path: String, completion: @escaping () -> Void) {
    
}

// MARK: - Helper Functions
private extension MovieListInteractor {
    func fetchPosterImage(for path: String, completion: @escaping() -> ()) {
        guard let url = URL(string: path) else {
            print("Invalid URL: \(path)")
            completion()
            return
        }

        if let cachedImage = ImageCache.shared.getImage(for: url) {
            DispatchQueue.main.async {
                self.presenter?.updateImage(posterPath: path, image: cachedImage)
            }
            completion()
            return
        }

        // Fetch from API if not cached
        apiWorker.loadImage(pathURL: path) { [weak self] data in
            guard let self = self else { return }

            if let data, let image = UIImage(data: data) {
                self.cacheAndStoreImage(image, url: url, data: data)
            } else {
                self.fallbackToLocalStorage(posterPath: path)
            }

            completion()
        }
    }
    
    private func cacheAndStoreImage(_ image: UIImage, url: URL, data: Data) {
        ImageCache.shared.saveImage(image, for: url)
        dbWorker.saveImage(ImageData(url: url.absoluteString, imagedata: data))

        DispatchQueue.main.async {
            self.presenter?.updateImage(posterPath: url.absoluteString, imageData: data)
        }
    }

    private func fallbackToLocalStorage(posterPath: String) {
        fecthDBImage(posterPath: posterPath)
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
    
    func fecthDBImage(posterPath: String) {
        dbWorker.fetchImage(imageURL: posterPath) { data in
            DispatchQueue.main.async {
                self.presenter?.updateImage(posterPath: posterPath, imageData: data)
            }
        }
    }
    
    func fecthDBMovies(request: MovieList.FetchMovies.Request) {
        dbWorker.fetchDBMovies(request: request) { movies in
            if let movies {
                self.currentPage += 1
                self.presenter?.presentMovies(response: movies)
            }
        }
    }
}
