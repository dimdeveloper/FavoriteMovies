//
//  MovieDetailsModels.swift
//  FavoriteMovies
//
//  Created by Dmytro Melnyk on 27.04.2025.
//

import Foundation

struct MovieViewModel {
    let id: String
    let title: String
    let overview: String
    let releaseDate: String
    let voteAverage: String
    
    var posterPath: String?
    var backdropPath: String?
}

enum MovieDetails {
    enum FetchMovie {
        struct Request {
            var movieID: String
        }
        struct Response {
            var movie: MovieResponceModel
        }
        
        struct ErrorModel {
            var error: RequestError
        }
        
        struct ViewModel {
            var presentedMovie: MovieViewModel
        }
    }
}
