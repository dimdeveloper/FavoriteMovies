//
//  MovieTableViewCell.swift
//  FavoriteMovies
//
//  Created by MyMacbook on 26.04.2025.
//

import Foundation
import UIKit

class MovieTableViewCell: UITableViewCell {
    
    private let movieImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.widthAnchor.constraint(equalToConstant: 128).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 188).isActive = true
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.textColor = .black
        label.numberOfLines = 1
        return label
    }()

    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .darkGray
        label.numberOfLines = 0
        return label
    }()

    private let releaseDateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .gray
        return label
    }()

    private let detailsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.alignment = .leading
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        contentView.backgroundColor = .clear
        backgroundColor = .clear
        
        let containerView = UIView()
        containerView.backgroundColor = UIColor.white
        containerView.layer.cornerRadius = 12
        containerView.layer.masksToBounds = true
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(containerView)

        NSLayoutConstraint.activate([
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
        ])
        
        detailsStackView.addArrangedSubview(titleLabel)
        detailsStackView.addArrangedSubview(descriptionLabel)
        detailsStackView.addArrangedSubview(releaseDateLabel)

        contentView.addSubview(movieImageView)
        contentView.addSubview(detailsStackView)

        NSLayoutConstraint.activate([
            movieImageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            movieImageView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 12),
            movieImageView.bottomAnchor.constraint(lessThanOrEqualTo: containerView.bottomAnchor, constant: -12),

            detailsStackView.leadingAnchor.constraint(equalTo: movieImageView.trailingAnchor, constant: 20),
            detailsStackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            detailsStackView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 12),
            detailsStackView.bottomAnchor.constraint(lessThanOrEqualTo: containerView.bottomAnchor, constant: -12)
        ])
    }

    func configure(with movie: MovieList.FetchMovies.ViewModel.MovieViewModel) {
        titleLabel.text = movie.title
        descriptionLabel.text = movie.overview
        releaseDateLabel.text = "Release: \(movie.releaseDate)"
        movieImageView.image = UIImage(systemName: "photo")
    }
    
    func updateImage(with image: UIImage) {
        movieImageView.image = image
    }
}
