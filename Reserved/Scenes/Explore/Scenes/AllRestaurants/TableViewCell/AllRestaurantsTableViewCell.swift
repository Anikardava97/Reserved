//
//  AllRestaurantsTableViewCell.swift
//  Reserved
//
//  Created by Ani's Mac on 19.01.24.
//

import UIKit

class AllRestaurantsTableViewCell: UITableViewCell {
    // MARK: - Properties
    private var restaurant: Restaurant?
    private var restaurantId: Int?
    var favoriteButtonDidTap: (() -> Void)?
    
    private let mainStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.spacing = 20
        stackView.alignment = .top
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.layoutMargins = .init(top: 12, left: 16, bottom: 12, right: 16)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let restaurantImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 12
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let favoriteButton: UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = .customAccentColor
        button.setImage(UIImage(systemName: "heart"), for: .normal)
        return button
    }()
    
    private lazy var detailsStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [titleLabel, ratingStackView, cuisineAndOpenNowStackView])
        stackView.axis = .vertical
        stackView.spacing = 12
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.textColor = .white
        label.numberOfLines = 1
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        return label
    }()
    
    private lazy var ratingStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [starImageView, ratingLabel])
        stackView.spacing = 6
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let starImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "star.fill")
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .yellow
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let ratingLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.textColor = .white
        label.numberOfLines = 1
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        return label
    }()
    
    private lazy var cuisineAndOpenNowStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [cuisineLabel, openNowLabel])
        stackView.axis = .vertical
        stackView.spacing = 4
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let cuisineLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.textColor = .white
        label.numberOfLines = 1
        label.font = UIFont.systemFont(ofSize: 10, weight: .regular)
        return label
    }()
    
    private let openNowLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.textColor = .white
        label.numberOfLines = 1
        label.font = UIFont.systemFont(ofSize: 10, weight: .regular)
        return label
    }()
    
    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        setupView()
        addSubviews()
        setupConstraints()
        setupFavoriteButtonAction()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - CellLifeCycle
    override func prepareForReuse() {
        super.prepareForReuse()
        
        restaurantImageView.image = nil
        titleLabel.text = nil
        ratingLabel.text = nil
        cuisineLabel.text = nil
        openNowLabel.text = nil
        favoriteButton.setImage(UIImage(systemName: "heart"), for: .normal)
    }
    
    // MARK: - Private Methods
    private func setupView() {
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
    
    private func addSubviews() {
        contentView.addSubview(mainStackView)
        mainStackView.addArrangedSubview(restaurantImageView)
        mainStackView.addArrangedSubview(detailsStackView)
        mainStackView.addArrangedSubview(favoriteButton)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            mainStackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            mainStackView.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            mainStackView.rightAnchor.constraint(equalTo: contentView.rightAnchor),
            mainStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            restaurantImageView.widthAnchor.constraint(equalToConstant: 120),
            restaurantImageView.heightAnchor.constraint(equalToConstant: 120),
            
            favoriteButton.topAnchor.constraint(equalTo: mainStackView.topAnchor, constant: 16),
            favoriteButton.trailingAnchor.constraint(equalTo: mainStackView.trailingAnchor, constant: -16),
            favoriteButton.widthAnchor.constraint(equalToConstant: 28),
            favoriteButton.heightAnchor.constraint(equalToConstant: 24),
            
            starImageView.widthAnchor.constraint(equalToConstant: 16),
            starImageView.heightAnchor.constraint(equalToConstant: 16)
        ])
    }
    
    private func setupFavoriteButtonAction() {
        favoriteButton.addAction(UIAction(handler: { [weak self] _ in
            self?.favoriteButtonDidTap?()
        }), for: .touchUpInside)
    }
    
    private func setOpenStatusLabel(for restaurant: Restaurant) {
        openNowLabel.text = RestaurantHoursManager.isRestaurantOpen(from: restaurant) ? "Open Now" : "Closed"
    }
    
    private func setImage(from url: String, for currentRestaurantId: Int) {
        NetworkManager.shared.downloadImage(from: url) { [weak self] image in
            DispatchQueue.main.async {
                if self?.restaurantId == currentRestaurantId {
                    self?.restaurantImageView.image = image
                }
            }
        }
    }
    
    // MARK: - Configure
    func configure(with restaurant: Restaurant, isFavorite: Bool) {
        self.restaurant = restaurant
        self.restaurantId = restaurant.id
        titleLabel.text = restaurant.name
        ratingLabel.text = String(restaurant.reviewStars)
        cuisineLabel.text = restaurant.cuisine
        
        if let imageURL = restaurant.mainImageURL {
            setImage(from: imageURL, for: restaurant.id)
        }
        
        setOpenStatusLabel(for: restaurant)
        
        let favoriteImageName = isFavorite ? "heart.fill" : "heart"
        favoriteButton.setImage(UIImage(systemName: favoriteImageName), for: .normal)
        
        backgroundColor = .customBackgroundColor
    }
}


