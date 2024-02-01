//
//  TablesCollectionViewCell.swift
//  Reserved
//
//  Created by Ani's Mac on 22.01.24.
//

import UIKit

class TablesCollectionViewCell: UICollectionViewCell {
    // MARK: - Properties
    private var isAvailable = false
    
    let tableImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
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
        tableImageView.image = nil
    }
    
    // MARK: - Private Methods
    private func addSubview() {
        contentView.addSubview(tableImageView)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            tableImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            tableImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            tableImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            tableImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
        ])
    }
    
    func animateAvailability(isAvailable: Bool) {
        if isAvailable {
            let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
            rotationAnimation.toValue = NSNumber(value: Double.pi * 2.0)
            rotationAnimation.duration = 2.5
            rotationAnimation.isCumulative = true
            rotationAnimation.repeatCount = Float.greatestFiniteMagnitude
            self.layer.add(rotationAnimation, forKey: "rotationAnimation")
        }
    }
}
