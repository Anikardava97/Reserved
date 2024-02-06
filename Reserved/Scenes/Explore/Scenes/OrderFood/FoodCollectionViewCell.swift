//
//  FoodCollectionViewCell.swift
//  Reserved
//
//  Created by Ani's Mac on 06.02.24.
//

import UIKit

protocol FoodCollectionViewCellDelegate: AnyObject {
    func addProduct(for cell: FoodCollectionViewCell?)
    func removeProduct(for cell: FoodCollectionViewCell?)
}

final class FoodCollectionViewCell: UICollectionViewCell {
    // MARK: - Properties
    weak var delegate: FoodCollectionViewCellDelegate?
    
    private lazy var mainStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [productImageView, productTitleLabel, productPriceLabel,ingredientsStackView, selectProductStackView])
        stackView.axis = .vertical
        stackView.spacing = 12
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.layoutMargins = UIEdgeInsets(top: 16, left: 24, bottom: 16, right: 24)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let productImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let productTitleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .white
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        return label
    }()
    
    private lazy var ingredientsStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [ingredientsListLabel])
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.spacing = 12
        stackView.backgroundColor = .customSecondaryColor
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.layoutMargins = UIEdgeInsets(top: 16, left: 24, bottom: 16, right: 24)
        stackView.layer.cornerRadius = 10
        return stackView
    }()
    
    private let ingredientsListLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.textColor = .white.withAlphaComponent(0.8)
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 14)
        
        return label
    }()
    
    private let productPriceLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        return label
    }()
    
    private lazy var selectProductStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [leadingSpacer, subtractProductButton, selectedQuantityLabel, addProductButton, trailingSpacer])
        stackView.alignment = .center
        stackView.spacing = 8
        return stackView
    }()
    
    private let leadingSpacer = UIView()
    private let trailingSpacer = UIView()
    
    private let subtractProductButton: CircularButton = {
        let button = CircularButton()
        button.setTitle("-", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 24)
        button.backgroundColor = .customSecondaryColor
        return button
    }()
    
    private let selectedQuantityLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        return label
    }()
    
    private let addProductButton: CircularButton = {
        let button = CircularButton()
        button.setTitle("+", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 24)
        button.backgroundColor = .customSecondaryColor
        return button
    }()
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview()
        setupConstraints()
        setupCellAppearance()
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
            
            leadingSpacer.widthAnchor.constraint(equalTo: trailingSpacer.widthAnchor),
            selectedQuantityLabel.widthAnchor.constraint(equalToConstant: 40),
            subtractProductButton.widthAnchor.constraint(equalTo: subtractProductButton.heightAnchor),
            addProductButton.widthAnchor.constraint(equalTo: addProductButton.heightAnchor),
            subtractProductButton.widthAnchor.constraint(equalToConstant: 32),
            addProductButton.widthAnchor.constraint(equalToConstant: 32)
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
        productPriceLabel.text = "$ \(product.price)"
        selectedQuantityLabel.text = "\(product.selectedAmount ?? 0)"
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 6
        
        let attributedText = NSMutableAttributedString(string: product.ingredients)
        attributedText.addAttribute(
            NSAttributedString.Key.paragraphStyle,
            value: paragraphStyle,
            range: NSMakeRange(0, attributedText.length)
        )
        ingredientsListLabel.attributedText = attributedText
    }
}

