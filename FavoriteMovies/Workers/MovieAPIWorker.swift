//
//  MovieAPIWorker.swift
//  FavoriteMovies
//
//  Created by Dmytro Melnyk on 26.04.2025.
//

import Foundation

protocol MovieAPIWorkerProtocol {
    func loadData(queryItem: URLQueryItem, completion: @escaping CompletionHandler)
    func loadImageData(imagePath: String, completion: @escaping (Data?) -> Void)
}

class MovieAPIWorker {
    var networkManager: MovieAPIWorkerProtocol
    
    init(networkManager: MovieAPIWorkerProtocol) {
      self.networkManager = networkManager
    }
    
    func fetchMovies(currentPage: Int, completion: @escaping CompletionHandler) {
        let pageQuery = URLQueryItem(name: "page", value: String(currentPage))
        networkManager.loadData(queryItem: pageQuery) { responce in
            completion(responce)
        }
    }
    
    func loadImage(pathURL: String?, completion: @escaping (Data?) -> Void) {
        guard let path = pathURL else {
            completion(nil)
            return
        }
        networkManager.loadImageData(imagePath: path) { data in
            completion(data)
        }
    }
}
