//
//  MovieListPresenter.swift
//  FavoriteMovies
//
//  Created by Dmytro Melnyk on 26.04.2025.
//

import Foundation
import UIKit

protocol MovieListPresenterLogic {
    func presentMovies(response: MovieList.FetchMovies.Response)
    func updateImage(posterPath: String, imageData: Data)
    func updateImage(posterPath: String, image: UIImage)
}

class MovieListPresenter: MovieListPresenterLogic {
    weak var viewController: MovieListDisplayLogic?
    
    func presentMovies(response: MovieList.FetchMovies.Response) {
        let movies = modelMap(fetchResult: response.movies)
        let viewModels = MovieList.FetchMovies.ViewModel(presentedMovies: movies)
        viewController?.displayMovies(viewModels.presentedMovies)
    }
    
    func updateImage(posterPath: String, imageData: Data) {
        if let posterImage = UIImage(data: imageData) {
            viewController?.updateMovieImage(posterPath: posterPath, image: posterImage)
        }
    }
    
    func updateImage(posterPath: String, image: UIImage) {
        viewController?.updateMovieImage(posterPath: posterPath, image: image)
    }
}

// MARK: - Helper functions
private extension MovieListPresenter {
    func modelMap(fetchResult: [MovieResponceModel]) -> [MovieListViewModel] {
        var movies: [MovieListViewModel] = []
        
        fetchResult.forEach { result in
            guard let id = result.id else {return}
            let movieName = result.originalTitle ?? Defaults.name
            let description = result.overview ?? Defaults.description
            let posterPath = result.posterPath
            let backdropPath = result.backdropPath
            let dateString = result.releaseDate != nil ? formatDate(from: result.releaseDate!) : Defaults.date
            let voteGrade = result.voteAverage != nil ? String(format: "%.1f", result.voteAverage!) : Defaults.voteGrade
            let movie = MovieListViewModel(id: String(id), title: movieName, overview: description, releaseDate: dateString, voteAverage: voteGrade, posterPath: posterPath, backdropPath: backdropPath)
            movies.append(movie)
        }
        return movies
    }
    
    private func formatDate(from dateString: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyy-MM-dd"
        guard let date = dateFormatter.date(from: dateString) else {return Defaults.date}
        dateFormatter.dateFormat = "dd.MM.yyyy"
        return dateFormatter.string(from: date)
    }
}
