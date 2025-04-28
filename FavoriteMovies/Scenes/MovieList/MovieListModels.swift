//
//  MovieListModels.swift
//  FavoriteMovies
//
//  Created by Dmytro Melnyk on 26.04.2025.
//

import Foundation
import UIKit

struct MovieListViewModel {
    let id: String
    let title: String
    let overview: String
    let releaseDate: String
    let voteAverage: String
    
    var posterPath: String?
    var backdropPath: String?
}

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
            var presentedMovies: [MovieListViewModel]
        }
    }
    
    enum FetchImages {
        struct ImageRequest {
            var path: String
        }
        struct ImageResponce {
            var data: Data
        }
    }
}
