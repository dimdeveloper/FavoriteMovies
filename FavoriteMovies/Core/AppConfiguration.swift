//
//  AppConfiguration.swift
//  FavoriteMovies
//
//  Created by Dmytro Melnyk on 26.04.2025.
//

import Foundation

struct Config: Decodable {
    let apiKey: String
    let popularMoviesURL: String
    let imageURL: String
}

enum AppConfigKeys: String {
    case apiKey = "apiKey"
    case popularMoviesURL = "popularMoviesURL"
    case imageURL = "imageURL"
    case movieDetails = "movieDetails"
}

final class AppConfig {
    static func value(for key: AppConfigKeys) -> String? {
        return Bundle.main.object(forInfoDictionaryKey: key.rawValue) as? String
    }
}
