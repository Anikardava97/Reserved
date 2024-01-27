//
//  FavoriteRestaurantsTableViewCell.swift
//  Reserved
//
//  Created by Ani's Mac on 27.01.24.
//

import UIKit

final class FavoriteRestaurantsTableViewCell: UITableViewCell {
    // MARK: - Properties
    private var restaurantId: Int?
    
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
        imageView.clipsToBounds = true
        // imageView.layer.cornerRadius = imageView.bounds.width / 2.0
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private let circularView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        view.layer.cornerRadius = 60
        view.backgroundColor = .white
        
        return view
    }()
    
    private let favoriteButton: UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = .customAccentColor
        button.setImage(UIImage(systemName: "heart"), for: .normal)
        return button
    }()
    
    private lazy var detailsStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [titleLabel, cuisineLabel])
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
        label.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        return label
    }()
    
    private let cuisineLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.textColor = .white
        label.numberOfLines = 1
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
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
    
    // MARK: - PrepareForReuse
    override func prepareForReuse() {
        super.prepareForReuse()
        restaurantImageView.image = nil
        titleLabel.text = nil
        cuisineLabel.text = nil
    }
    
    // MARK: - Configure
    func configure(with restaurant: MockRestaurant) {
        //        self.restaurantId = restaurant.id
        titleLabel.text = restaurant.name
        cuisineLabel.text = restaurant.cuisine
        restaurantImageView.image = restaurant.image
        backgroundColor = .customBackgroundColor
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
        mainStackView.addArrangedSubview(circularView)
        circularView.addSubview(restaurantImageView)
        mainStackView.addArrangedSubview(detailsStackView)
        mainStackView.addArrangedSubview(favoriteButton)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            mainStackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            mainStackView.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            mainStackView.rightAnchor.constraint(equalTo: contentView.rightAnchor),
            mainStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            circularView.widthAnchor.constraint(equalToConstant: 120),
            circularView.heightAnchor.constraint(equalToConstant: 120),
            
            restaurantImageView.topAnchor.constraint(equalTo: circularView.topAnchor),
            restaurantImageView.leadingAnchor.constraint(equalTo: circularView.leadingAnchor),
            restaurantImageView.trailingAnchor.constraint(equalTo: circularView.trailingAnchor),
            restaurantImageView.bottomAnchor.constraint(equalTo: circularView.bottomAnchor),
            
            favoriteButton.topAnchor.constraint(equalTo: mainStackView.topAnchor, constant: 16),
            favoriteButton.trailingAnchor.constraint(equalTo: mainStackView.trailingAnchor, constant: -16),
            favoriteButton.widthAnchor.constraint(equalToConstant: 28),
            favoriteButton.heightAnchor.constraint(equalToConstant: 24),
        ])
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
}
