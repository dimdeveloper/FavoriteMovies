//
//  Movie.swift
//  FavoriteMovies
//
//  Created by Dmytro Melnyk on 26.04.2025.
//

import Foundation

struct Movie: Codable {
    let id: String
    let title: String
    let overview: String
    let releaseDate: String
    let voteAverage: Double

    var posterData: Data?
    var backdropData: Data?
}
