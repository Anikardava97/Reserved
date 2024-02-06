//
//  FoodCollectionViewCell.swift
//  Reserved
//
//  Created by Ani's Mac on 06.02.24.
//

import UIKit

protocol FoodCellDelegate: AnyObject {
    func addProduct(for cell: FoodCollectionViewCell?)
    func removeProduct(for cell: FoodCollectionViewCell?)
}

final class FoodCollectionViewCell: UICollectionViewCell {
    // MARK: - Properties
    private lazy var mainStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [productImageView, productInfoStackView])
        stackView.spacing = 8
        stackView.distribution = .equalSpacing
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.layoutMargins = .init(top: 8, left: 16, bottom: 8, right: 16)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var productInfoStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [productTitleLabel, productPriceLabel, selectProductStackView, ingredientsStackView])
        stackView.axis = .vertical
        stackView.spacing = 4
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let productImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let productTitleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.textColor = .white
        label.numberOfLines = 1
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        return label
    }()
    
    private let productPriceLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        return label
    }()
    
    private lazy var selectProductStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [subtractProductButton, selectedQuantityLabel, addProductButton])
        stackView.distribution = .equalSpacing
        stackView.alignment = .center
        stackView.spacing = 4
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let subtractProductButton: UIButton = {
        let button = UIButton()
        button.setTitle("-", for: .normal)
        button.setTitleColor(.blue, for: .normal)
        return button
    }()
    
    private let selectedQuantityLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        return label
    }()
    
    private let addProductButton: UIButton = {
        let button = UIButton()
        button.setTitle("+", for: .normal)
        button.setTitleColor(.blue, for: .normal)
        return button
    }()
    
    private lazy var ingredientsStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [ingredientsTitleLabel, ingredientsListLabel])
        stackView.distribution = .equalSpacing
        stackView.alignment = .center
        stackView.spacing = 4
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let ingredientsTitleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.textColor = .white
        label.numberOfLines = 1
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        return label
    }()
    
    private let ingredientsListLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.textColor = .white
        label.numberOfLines = 1
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        return label
    }()
    
    weak var delegate: FoodCellDelegate?

    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview()
        setupConstraints()
        addActions()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    // MARK: - CellLifeCycle
    override func prepareForReuse() {
        super.prepareForReuse()
        
        productImageView.image = nil
        productTitleLabel.text = nil
        productPriceLabel.text = nil
        selectedQuantityLabel.text = nil
        ingredientsTitleLabel.text = nil
        ingredientsListLabel.text = nil
    }
    
    // MARK: - Private Methods
    private func addSubview() {
        contentView.addSubview(mainStackView)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            mainStackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            mainStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            mainStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            mainStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            productImageView.widthAnchor.constraint(equalToConstant: 200),
            productImageView.heightAnchor.constraint(equalToConstant: 200),
        ])
    }
    
    private func addActions() {
        addProductButton.addAction(UIAction(title: "", handler: { [weak self] _ in
            self?.delegate?.addProduct(for: self)
        }), for: .touchUpInside)
        
        subtractProductButton.addAction(UIAction(title: "", handler: { [weak self] _ in
            self?.delegate?.removeProduct(for: self)
        }), for: .touchUpInside)
    }
    
    private func setImage(from url: String) {
        NetworkManager.shared.downloadImage(from: url) { [weak self] image in
            DispatchQueue.main.async {
             self?.productImageView.image = image
            }
        }
    }
    
    func updateQuantityLabel(with product: FoodItem) {
        selectedQuantityLabel.text = "\(product.selectedAmount ?? 0)"
    }
    
    // MARK: - Configuration
    func configure(with product: FoodItem) {
        setImage(from: product.image)
        productTitleLabel.text = product.name
        productPriceLabel.text = "\(product.price)"
        ingredientsListLabel.text = "\(product.ingredients)"
    }
}

