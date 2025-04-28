//
//  MovieDetailsPresenter.swift
//  FavoriteMovies
//
//  Created by Dmytro Melnyk on 27.04.2025.
//

import Foundation
import UIKit

protocol MovieDetailsPresenterLogic {
    func presentMovieImage(imageData: Data?)
    func presentMovie(response: MovieDetails.FetchMovie.Response)
}

class MovieDetailsPresenter: MovieDetailsPresenterLogic {
    weak var viewController: MovieDetailsViewController?
    
    func presentMovie(response: MovieDetails.FetchMovie.Response) {
        let movie = modelMap(fetchResult: response.movie)
        let viewModel = MovieDetails.FetchMovie.ViewModel(presentedMovie: movie)
        viewController?.displayMovieDetails(viewModel: viewModel.presentedMovie)
    }
    
    private func modelMap(fetchResult: MovieResponceModel) -> MovieViewModel {
            let id = fetchResult.id
            let movieName = fetchResult.originalTitle ?? Defaults.name
            let description = fetchResult.overview ?? Defaults.description
            let posterPath = fetchResult.posterPath
            let backdropPath = fetchResult.backdropPath
            let dateString = fetchResult.releaseDate != nil ? formatDate(from: fetchResult.releaseDate!) : Defaults.date
            let voteGrade = fetchResult.voteAverage != nil ? String(format: "%.1f", fetchResult.voteAverage!) : Defaults.voteGrade
            let movie = MovieViewModel(id: String(id ?? 0), title: movieName, overview: description, releaseDate: dateString, voteAverage: voteGrade, posterPath: posterPath, backdropPath: backdropPath)
        
        return movie
    }
    
    func presentMovieImage(imageData: Data?) {
        if let data = imageData, let image = UIImage(data: data) {
            viewController?.updateImage(with: image)
        } else {
            print("Error converting Image from Data")
        }
    }
    
    private func formatDate(from dateString: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyy-MM-dd"
        guard let date = dateFormatter.date(from: dateString) else {return Defaults.date}
        dateFormatter.dateFormat = "dd.MM.yyyy"
        return dateFormatter.string(from: date)
    }
}
