//
//  TopRestaurantCollectionViewCell.swift
//  Reserved
//
//  Created by Ani's Mac on 19.01.24.
//

import UIKit

final class TopRestaurantCollectionViewCell: UICollectionViewCell {
    // MARK: - Properties
    private let restaurantImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var topButtonStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [favoriteButton])
        stackView.distribution = .equalSpacing
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let favoriteButton: UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = .customAccentColor
        button.setImage(UIImage(systemName: "heart"), for: .normal)
        return button
    }()
    
    private lazy var titleCuisineStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [titleLabel, cuisineLabel])
        stackView.axis = .vertical
        stackView.spacing = 4
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.textColor = .white
        label.numberOfLines = 1
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        return label
    }()
    
    private let cuisineLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.textColor = .white
        label.numberOfLines = 1
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        return label
    }()
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview()
        setupConstraints()
        setupFavoriteButtonAction()
        setupCellAppearance()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    // MARK: - CellLifeCycle
    override func prepareForReuse() {
        super.prepareForReuse()
        restaurantImageView.image = nil
        titleLabel.text = nil
        cuisineLabel.text = nil
        favoriteButton.setImage(UIImage(systemName: "heart"), for: .normal)
    }
    
    // MARK: - Private Methods
    private func addSubview() {
        contentView.addSubview(restaurantImageView)
        contentView.addSubview(topButtonStackView)
        contentView.addSubview(titleCuisineStackView)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            restaurantImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            restaurantImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            restaurantImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            restaurantImageView.heightAnchor.constraint(equalToConstant: 135),

            topButtonStackView.topAnchor.constraint(equalTo: restaurantImageView.topAnchor, constant: 10),
            topButtonStackView.trailingAnchor.constraint(equalTo: restaurantImageView.trailingAnchor, constant: -10),

            titleCuisineStackView.topAnchor.constraint(equalTo: restaurantImageView.bottomAnchor, constant: 12),
            titleCuisineStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 14),
            titleCuisineStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -14)
        ])
    }
    
    private func setupCellAppearance() {
        layer.borderColor = UIColor.gray.withAlphaComponent(0.1).cgColor
        layer.borderWidth = 1.0
        layer.cornerRadius = 12
        
        contentView.layer.cornerRadius = layer.cornerRadius
        contentView.layer.masksToBounds = true
        
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 4)
        layer.shadowRadius = 6.0
        layer.shadowOpacity = 0.1
        layer.masksToBounds = false
    }
    
    private func setupFavoriteButtonAction() {
        favoriteButton.addAction(
            UIAction(
                title: "",
                handler: { [weak self] _ in
                    let isFavorite = self?.favoriteButton.currentImage == UIImage(systemName: "heart.fill")
                    self?.favoriteButton.setImage(UIImage(systemName: isFavorite ? "heart" : "heart.fill"), for: .normal)
                }
            ),
            for: .touchUpInside
        )
    }
    
    // MARK: - Configuration
    func configure(with restaurant: Restaurant) {
        titleLabel.text = restaurant.name
        cuisineLabel.text = restaurant.cuisine
        setImage(from: restaurant.mainImageURL)
    }
    
    private func setImage(from url: String) {
        NetworkManager.shared.downloadImage(from: url) { [weak self] image in
            DispatchQueue.main.async {
                if let weakSelf = self, weakSelf.restaurantImageView.image == nil {
                    weakSelf.restaurantImageView.image = image
                }
            }
        }
    }
}

