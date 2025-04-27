//
//  MovieListViewController.swift
//  FavoriteMovies
//
//  Created by Dmytro Melnyk on 26.04.2025.
//

import Foundation
import UIKit

protocol MovieListDisplayLogic: AnyObject {
    func displayMovies(_ viewModels: [MovieList.FetchMovies.ViewModel.MovieViewModel])
    func updateMovieImage(posterPath: String, image: UIImage)
}

class MovieListViewController: UITableViewController, MovieListDisplayLogic {
    var interactor: MovieListInteractor?
    var router: MovieListRouter?
    var movies: [MovieList.FetchMovies.ViewModel.MovieViewModel] = []
    var indexPathsForVisibleRows: [IndexPath] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setup()
        fetchMovies()
        
        print("View loaded")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        tableView.dataSource = self
//        tableView.delegate = self
//
//        fetchOrders()
    }
    
    private func setupTableView() {
        tableView.register(MovieTableViewCell.self, forCellReuseIdentifier: "MovieCell")
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        tableView.backgroundColor = .background
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 200
    }
    
    private func setup() {
        let viewController = self
        let interactor = MovieListInteractor()
        let presenter = MovieListPresenter()
        let router = MovieListRouter()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = interactor
    }
    
    func fetchMovies() {
        interactor?.fetchMovies()
    }
    
    func displayMovies(_ viewModels: [MovieList.FetchMovies.ViewModel.MovieViewModel]) {
        let previousCount = movies.count
            movies.append(contentsOf: viewModels)
//            let indexPaths = (previousCount..<movies.count).map { IndexPath(row: $0, section: 0) }
//            tableView.insertRows(at: indexPaths, with: .fade)
//        if self.movies.isEmpty {
//            self.movies = viewModels
//        } else {
//            viewModels.forEach { newMovie in
//                if !self.movies.contains(where: {$0.id == newMovie.id} ) {
//                    self.movies.append(newMovie)
//                }
//            }
//        }
        tableView.reloadData()
    }
    
    func updateMovieImage(posterPath: String, image: UIImage) {
        if let index = movies.firstIndex(where: { $0.posterPath == posterPath }) {
                let indexPath = IndexPath(row: index, section: 0)
                if let cell = tableView.cellForRow(at: indexPath) as? MovieTableViewCell {
                    cell.updateImage(with: image)
                }
            }
        }
    
}

extension MovieListViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell", for: indexPath) as? MovieTableViewCell else {
            return UITableViewCell()
        }
//        if let visibleIndexPaths = tableView.indexPathsForVisibleRows {
//            let newVisibleIndexPath = visibleIndexPaths.filter { !indexPathsForVisibleRows.contains($0) }
//            let visibleMovies = newVisibleIndexPath.map { movies[$0.row] }
//            interactor?.fetchImage(for: visibleMovies)
//            indexPathsForVisibleRows = visibleIndexPaths
//            // TODO: Delete print
//            print("New movies: \(visibleMovies.map {$0.title})")
//        }
        let movie = movies[indexPath.row]
        interactor?.fetchImage(for: movie)
        cell.configure(with: movie)
        
        return cell
    }
}

extension MovieListViewController {

    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let visibleHeight = scrollView.frame.height

        if offsetY > contentHeight - visibleHeight - 100 {
            interactor?.fetchMovies()
        }
    }
}
