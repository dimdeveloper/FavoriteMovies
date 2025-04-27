//
//  MovieEntity + Extensions.swift
//  FavoriteMovies
//
//  Created by MyMacbook on 26.04.2025.
//

import Foundation

extension MovieEntity {
    static func from(entity: MovieEntity) -> Movie {
        return Movie(
            id: entity.id ?? "",
            title: entity.title ?? "",
            overview: entity.overview ?? "",
            releaseDate: entity.releaseDate ?? "",
            voteAverage: entity.voteAverage,
            posterPath: entity.posterImage,
            backdropPath: entity.backdropImage
        )
    }
}
