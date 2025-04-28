//
//  MovieListViewController.swift
//  FavoriteMovies
//
//  Created by Dmytro Melnyk on 26.04.2025.
//

import Foundation
import UIKit

protocol MovieListDisplayLogic: AnyObject {
    func displayMovies(_ viewModels: [MovieListViewModel])
    func updateMovieImage(posterPath: String, image: UIImage)
}

class MovieListViewController: UITableViewController, MovieListDisplayLogic {
    var interactor: MovieListLogic?
    var router: ListRouter?
    var movies: [MovieListViewModel] = []
    var indexPathsForVisibleRows: [IndexPath] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setup()
        fetchMovies()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        title = "MovieToGo"
        navigationController?.navigationBar.prefersLargeTitles = true
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
        let router = MovieListRouter(viewController: self)
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
    }
    
    func fetchMovies() {
        interactor?.fetchMovies()
    }
    
    func displayMovies(_ viewModels: [MovieListViewModel]) {
        let previousCount = movies.count
            movies.append(contentsOf: viewModels)

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

        let movie = movies[indexPath.row]
        interactor?.fetchImage(for: movie)
        cell.configure(with: movie)
        
        return cell
    }
}

extension MovieListViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let movieID = movies[indexPath.row].id
        let request = MovieDetails.FetchMovie.Request(movieID: movieID)
        router?.routeToDetailsView(with: request)
    }
    // create pagination behavior
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let visibleHeight = scrollView.frame.height

        if offsetY > contentHeight - visibleHeight - 100 {
            interactor?.fetchMovies()
        }
    }
}
