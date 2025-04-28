//
//  MovieDetailsRouter.swift
//  FavoriteMovies
//
//  Created by Dmytro Melnyk on 27.04.2025.
//

import Foundation

class MovieDetailsRouter {
    weak var viewController: MovieDetailsViewController?

    init(viewController: MovieDetailsViewController) {
        self.viewController = viewController
    }
}
