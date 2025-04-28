//
//  MovieEntity + Extensions.swift
//  FavoriteMovies
//
//  Created by MyMacbook on 26.04.2025.
//

import Foundation

extension MovieEntity {
    static func from(entity: MovieEntity) -> MovieResponceModel {
        return MovieResponceModel(
            id: Int(entity.id ?? ""),
            originalTitle: entity.title ?? "Original title is missing",
            overview: entity.overview ?? "Description is missing",
            posterPath: entity.releaseDate ?? "--//--//--",
            releaseDate: entity.releaseDate,
            backdropPath: entity.posterImage,
            voteAverage: entity.voteAverage
        )
    }
}
