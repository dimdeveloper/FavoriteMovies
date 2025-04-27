//
//  MovieListModels.swift
//  FavoriteMovies
//
//  Created by Dmytro Melnyk on 26.04.2025.
//

import Foundation
import UIKit

enum MovieList {
    enum FetchMovies {
        struct Request {
            var page: Int
        }
        struct Response {
            var movies: [MovieResponceModel]
        }
        
        struct ErrorModel {
            var error: RequestError
        }
        struct ViewModel {
            struct MovieViewModel {
                let id: String
                let title: String
                let overview: String
                let releaseDate: String
                let voteAverage: String
                
                var posterPath: String?
                var backdropPath: String?
            }
            var presentedMovies: [MovieViewModel]
        }
    }
}
