//
//  NetworkManager.swift
//  FavoriteMovies
//
//  Created by Dmytro Melnyk on 26.04.2025.
//

import Foundation

enum RequestError: Error {
    case timeoutError
    case urlGeneration
    case dataError
    case decodeError
    case fetchFailed
}

typealias CompletionHandler = (Result<MoviesResponce, RequestError>) -> Void
typealias SingleMovieCompletionHandler = (Result<MovieResponceModel, RequestError>) -> Void

class NetworkManager: MovieAPIWorkerProtocol {

    static let shared = NetworkManager()
    
    private let session: URLSession
    private let apiKeyName = "api_key"
    private let maxRetries = 3
    
    private init() {
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = 10
        config.timeoutIntervalForResource = 30
        session = URLSession(configuration: config)
    }
    
    func fetchData<T: Decodable>(url: URL?, retryCount: Int, completion: @escaping (Result<T, RequestError>) -> Void) {
        guard let url = url else {
            DispatchQueue.main.async { completion(.failure(.urlGeneration)) }
            return
        }
        
        session.dataTask(with: url) { [weak self] data, _, error in
            guard let self = self else { return }
            
            if let error, (error as NSError).code == NSURLErrorTimedOut, retryCount > 0 {
                print("Request timed out! Retrying... (\(retryCount) attempts left)")
                self.fetchData(url: url, retryCount: retryCount - 1, completion: completion)
                return
            }
            
            guard let data else {
                DispatchQueue.main.async { completion(.failure(.dataError)) }
                return
            }
            
            do {
                let result = try JSONDecoder().decode(T.self, from: data)
                DispatchQueue.main.async { completion(.success(result)) }
            } catch {
                DispatchQueue.main.async { completion(.failure(.decodeError)) }
            }
        }.resume()
    }
    
    // MARK: - Fetch Movies
    func loadMoviesData(queryItem: URLQueryItem, completion: @escaping CompletionHandler) {
        guard let stringURL = AppConfig.value(for: .popularMoviesURL),
              var requestURL = URL(string: stringURL),
              let apiKey = AppConfig.value(for: .apiKey) else {
            completion(.failure(.urlGeneration))
            return
        }
        
        requestURL.appendQueryItems([
            URLQueryItem(name: apiKeyName, value: apiKey),
            queryItem
        ])
        
        fetchData(url: requestURL, retryCount: maxRetries, completion: completion)
    }
    
    // MARK: - Fetch Single Movie
    func loadSingleMovieData(movieID: String, completion: @escaping SingleMovieCompletionHandler) {
        guard let stringURL = AppConfig.value(for: .movieDetails),
              var components = URLComponents(string: stringURL),
              let apiKey = AppConfig.value(for: .apiKey) else {
            completion(.failure(.urlGeneration))
            return
        }
        
        components.path += "\(movieID)"
        components.queryItems = [URLQueryItem(name: apiKeyName, value: apiKey)]
        
        fetchData(url: components.url, retryCount: maxRetries, completion: completion)
    }
    
    // MARK: - Fetch Image
    func loadImageData(imagePath: String, completion: @escaping (Data?) -> Void) {
        guard let stringImageURL = AppConfig.value(for: .imageURL),
              let requestURL = URL(string: "\(stringImageURL)\(imagePath)") else {
            completion(nil)
            return
        }
        
        session.dataTask(with: requestURL) { [weak self] data, _, error in
            guard let self = self else { return }
            
            if let error, (error as NSError).code == NSURLErrorTimedOut {
                print("Image request timed out! Retrying...")
                self.loadImageData(imagePath: imagePath, completion: completion)
                return
            }
            
            DispatchQueue.main.async { completion(data) }
        }.resume()
    }
}

extension URL {
    mutating func appendQueryItems(_ queryItems: [URLQueryItem]) {
        guard var urlComponents = URLComponents(string: absoluteString) else { return }
        urlComponents.queryItems = (urlComponents.queryItems ?? []) + queryItems
        
        if let newURL = urlComponents.url {
            self = newURL
        }
    }
}
