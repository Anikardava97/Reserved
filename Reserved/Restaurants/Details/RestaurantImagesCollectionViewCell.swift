//
//  RestaurantImagesCollectionViewCell.swift
//  Reserved
//
//  Created by Ani's Mac on 20.01.24.
//

import UIKit

final class RestaurantImagesCollectionViewCell: UICollectionViewCell {
    // MARK: - Properties
    let restaurantImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    // MARK: - CellLifeCycle
    override func prepareForReuse() {
        super.prepareForReuse()
        restaurantImageView.image = nil
    }
    
    // MARK: - Private Methods
    private func addSubview() {
        contentView.addSubview(restaurantImageView)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            restaurantImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            restaurantImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            restaurantImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            restaurantImageView.heightAnchor.constraint(equalToConstant: 400)
        ])
    }
}