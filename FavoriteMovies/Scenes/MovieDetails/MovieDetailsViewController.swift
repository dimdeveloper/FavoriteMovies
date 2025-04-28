//
//  MovieDetailsViewController.swift
//  FavoriteMovies
//
//  Created by Dmytro Melnyk on 27.04.2025.
//

import Foundation
import UIKit

protocol MovieDetailsDisplayLogic: AnyObject {
    func displayMovieDetails(viewModel: MovieViewModel)
    func updateImage(with: UIImage)
}

class MovieDetailsViewController: UIViewController, MovieDetailsDisplayLogic {
    private var movie: MovieViewModel?
    private let movieImageView = UIImageView()
    private let titleLabel = UILabel()
    private let scoreView = UIStackView()
    private let scoreLabel = UILabel()
    private let scoreImageView = UIImageView()
    private let descriptionStack = UIStackView()
    private let descriptionTitleLabel = UILabel()
    private let descriptionLabel = UILabel()
    private let releaseDateLabel = UILabel()

    var interactor: MovieDetailsInteractor?
    
    private var router: MovieDetailsRouter?
    private var movieID: String
    
    init(movieId: String) {
        self.movieID = movieId
        super.init(nibName: nil, bundle: nil)
        view.backgroundColor = .white
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func displayMovieDetails(viewModel: MovieViewModel) {
        setupUI(movie: viewModel)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.prefersLargeTitles = false
    }

    func updateImage(with image: UIImage) {
        movieImageView.image = image
    }
}

// MARK: Private etensions
private extension MovieDetailsViewController {
    func setup() {
        let viewController = self
        let interactor = MovieDetailsInteractor()
        let presenter = MovieDetailsPresenter()
        let router = MovieDetailsRouter(viewController: self)
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        let request = MovieDetails.FetchMovie.Request(movieID: movieID)
        interactor.fetchMovieDetails(request: request)
    }
    
    func setupUI(movie: MovieViewModel) {
        let titleLabel = UILabel()
        titleLabel.text = movie.title
        titleLabel.font = UIFont.boldSystemFont(ofSize: 18)
        titleLabel.textAlignment = .center
        
        let containerView = UIView(frame: CGRect(x: 0, y: 0, width: 200, height: 40))
        containerView.addSubview(titleLabel)
        titleLabel.frame = containerView.bounds
        
        navigationItem.titleView = containerView
        
        movieImageView.image = UIImage(systemName: "photo")
        movieImageView.contentMode = .scaleAspectFill
        movieImageView.layer.cornerRadius = 12
        movieImageView.clipsToBounds = true
        movieImageView.translatesAutoresizingMaskIntoConstraints = false

        scoreLabel.text = "\(movie.voteAverage)"
        scoreLabel.font = UIFont.boldSystemFont(ofSize: 18)
        scoreImageView.image = UIImage(named: "Star")

        scoreView.axis = .horizontal
        scoreView.spacing = 8
        scoreView.addArrangedSubview(scoreImageView)
        scoreView.addArrangedSubview(scoreLabel)
        scoreView.translatesAutoresizingMaskIntoConstraints = false

        titleLabel.text = movie.title
        titleLabel.font = UIFont.boldSystemFont(ofSize: 22)
        titleLabel.textColor = .white

        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        scoreView.translatesAutoresizingMaskIntoConstraints = false
        movieImageView.addSubview(titleLabel)
        movieImageView.addSubview(scoreView)

        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: movieImageView.leadingAnchor, constant: 16),
            titleLabel.bottomAnchor.constraint(equalTo: movieImageView.bottomAnchor, constant: -16),
            
            scoreView.trailingAnchor.constraint(equalTo: movieImageView.trailingAnchor, constant: -16),
            scoreView.bottomAnchor.constraint(equalTo: movieImageView.bottomAnchor, constant: -16)
        ])


        descriptionTitleLabel.text = "Description:"
        descriptionTitleLabel.font = UIFont.boldSystemFont(ofSize: 18)
        
        descriptionLabel.text = movie.overview
        descriptionLabel.numberOfLines = 0
        
        releaseDateLabel.text = "Release Date: \(movie.releaseDate)"
        releaseDateLabel.font = UIFont.systemFont(ofSize: 16)

        descriptionStack.axis = .vertical
        descriptionStack.spacing = 8
        descriptionStack.addArrangedSubview(descriptionTitleLabel)
        descriptionStack.addArrangedSubview(descriptionLabel)
        descriptionStack.addArrangedSubview(releaseDateLabel)
        descriptionStack.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(movieImageView)
        view.addSubview(descriptionStack)

        descriptionStack.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            movieImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
            movieImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            movieImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            movieImageView.heightAnchor.constraint(equalToConstant: 250),

            descriptionStack.topAnchor.constraint(equalTo: movieImageView.bottomAnchor, constant: 16),
            descriptionStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            descriptionStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
    }
}
