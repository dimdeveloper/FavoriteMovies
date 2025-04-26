//
//  NetworkManager.swift
//  FavoriteMovies
//
//  Created by Dmytro Melnyk on 26.04.2025.
//

import Foundation

enum RequestError: Error {
    case error(statusCode: Int, data: Data?)
    case notConnected
    case generic(Error)
    case urlGeneration
    case dataError
    case decodeError
}

typealias CompletionHandler = (Result<MoviesResponce, RequestError>) -> Void

class NetworkManager: MovieAPIWorkerProtocol {
    
    static let shared = NetworkManager()
    private let session: URLSession
    
    private let apiKeyName = "api_key"


    private init() {
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = 30 // Set timeout
        config.timeoutIntervalForResource = 60
        session = URLSession(configuration: config)
    }
    
    func loadData(queryItem: URLQueryItem, completion: @escaping CompletionHandler) {
        guard let stringURL = AppConfig.value(for: .popularMoviesURL), var requestURL = URL(string: stringURL), let apiKey = AppConfig.value(for: .apiKey) else {
            completion(.failure(.urlGeneration))
            return
        }
        
        let queryItems = [
            URLQueryItem(name: apiKeyName, value: apiKey),
            queryItem
        ]
        
        requestURL.appendQueryItems(queryItems)
        
        session.dataTask(with: requestURL) { data, response, error in
            if let error = error {
                let requestError = self.handleNetworkError(error: error, response: response, data: data)
                DispatchQueue.main.async { completion(.failure(requestError)) }
                return
            }
            
            guard let data = data else {
                DispatchQueue.main.async { completion(.failure(.dataError)) }
                return
            }
            
            do {
                let result = try JSONDecoder().decode(MoviesResponce.self, from: data)
                DispatchQueue.main.async { completion(.success(result)) }
            } catch {
                print("Decoding error:", error)
                DispatchQueue.main.async { completion(.failure(.decodeError)) }
            }
        }.resume()
    }
    
    func loadImageData(imagePath: String, completion: @escaping (Data?) -> Void) {
        guard let stringImageURL = AppConfig.value(for: .popularMoviesURL), let requestURL = URL(string: "\(stringImageURL)\(imagePath)") else {
            completion(nil)
            return
        }

        session.dataTask(with: requestURL) { data, _, error in
            DispatchQueue.main.async { completion(error == nil ? data : nil) }
        }.resume()
    }
    
    private func handleNetworkError(error: Error, response: URLResponse?, data: Data?) -> RequestError {
        if let response = response as? HTTPURLResponse {
            return .error(statusCode: response.statusCode, data: data)
        }
        
        let errorCode = URLError.Code(rawValue: (error as NSError).code)
        
        switch errorCode {
        case .notConnectedToInternet:
            return .notConnected
        default:
            return .generic(error)
        }
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
