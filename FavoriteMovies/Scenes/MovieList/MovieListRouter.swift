//
//  MovieListRouter.swift
//  FavoriteMovies
//
//  Created by Dmytro Melnyk on 26.04.2025.
//

import Foundation
import UIKit

protocol ListRouter {
    func routeToDetailsView(with movieID: MovieDetails.FetchMovie.Request)
}

class MovieListRouter: ListRouter {
    weak var viewController: MovieListViewController?

    init(viewController: MovieListViewController) {
        self.viewController = viewController
    }
    
    func routeToDetailsView(with movieID: MovieDetails.FetchMovie.Request) {
        let movieDetailsVC = MovieDetailsViewController(movieId: movieID.movieID)
        movieDetailsVC.interactor?.fetchMovieDetails(request: movieID)
        viewController?.navigationController?.pushViewController(movieDetailsVC, animated: true)
    }
}
