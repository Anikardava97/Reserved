//
//  TablesCollectionViewCell.swift
//  Reserved
//
//  Created by Ani's Mac on 22.01.24.
//

import UIKit

class TablesCollectionViewCell: UICollectionViewCell {
    // MARK: - Properties
    let tableButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 12
        button.backgroundColor = .black.withAlphaComponent(0.1)
        button.clipsToBounds = true
        return button
    }()
    
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
        contentView.addSubview(tableButton)
        tableButton.addSubview(tableImageView)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
                   tableButton.topAnchor.constraint(equalTo: contentView.topAnchor),
                   tableButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
                   tableButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
                   tableButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
                   
                   tableImageView.centerXAnchor.constraint(equalTo: tableButton.centerXAnchor),
                   tableImageView.centerYAnchor.constraint(equalTo: tableButton.centerYAnchor),
                   tableImageView.widthAnchor.constraint(equalTo: tableButton.widthAnchor, multiplier: 0.8),
                   tableImageView.heightAnchor.constraint(equalTo: tableButton.heightAnchor, multiplier: 0.8)
               ])
    }
}
