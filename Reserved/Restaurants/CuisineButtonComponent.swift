//
//  CuisineButtonComponent.swift
//  Reserved
//
//  Created by Ani's Mac on 19.01.24.
//

import UIKit

final class CuisineButtonComponent: UIButton {
    // MARK: - Properties
    private let customView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods
    private func setupUI() {
        addSubview(customView)
        customView.addSubview(iconImageView)
        customView.addSubview(nameLabel)
        
        NSLayoutConstraint.activate([
            customView.leadingAnchor.constraint(equalTo: leadingAnchor),
            customView.trailingAnchor.constraint(equalTo: trailingAnchor),
            customView.topAnchor.constraint(equalTo: topAnchor),
            customView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            iconImageView.centerYAnchor.constraint(equalTo: customView.centerYAnchor),
            iconImageView.leadingAnchor.constraint(equalTo: customView.leadingAnchor, constant: 12),
            iconImageView.heightAnchor.constraint(equalToConstant: 18),
            iconImageView.widthAnchor.constraint(equalToConstant: 18),
            
            nameLabel.centerYAnchor.constraint(equalTo: customView.centerYAnchor),
            nameLabel.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 6),
            nameLabel.trailingAnchor.constraint(equalTo: customView.trailingAnchor, constant: -18)
        ])
        
        customView.layer.cornerRadius = 8
    }
    
    func configure(with backgroundColor: UIColor, icon: UIImage?, name: String) {
        customView.backgroundColor = backgroundColor
        iconImageView.image = icon
        nameLabel.text = name
    }
}

