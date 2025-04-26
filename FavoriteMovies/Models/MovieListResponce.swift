//
//  Movie.swift
//  FavoriteMovies
//
//  Created by Dmytro Melnyk on 25.04.2025.
//

import Foundation

struct MovieListResponse: Codable {
    let page: Int
    let results: [MovieResponce]
}

struct MovieResponce: Codable {
    let id: Int
    let title: String
    let originalTitle: String
    let overview: String
    let releaseDate: String
    let posterPath: String
    let backdropPath: String
    let voteAverage: Double
    // FIXME: move url to app configuration
    var posterURL: URL? {
        return URL(string: "https://image.tmdb.org/t/p/w500\(posterPath)")
    }
// FIXME: move url to app configuration
    var backdropURL: URL? {
        return URL(string: "https://image.tmdb.org/t/p/w780\(backdropPath)")
    }
}


