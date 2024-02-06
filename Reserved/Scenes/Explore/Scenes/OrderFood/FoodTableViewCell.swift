//
//  FoodTableViewCell.swift
//  Reserved
//
//  Created by Ani's Mac on 06.02.24.
//

import UIKit

protocol FoodTableViewCellDelegate: AnyObject {
    func addProduct(for cell: FoodTableViewCell?)
    func removeProduct(for cell: FoodTableViewCell?)
}

final class FoodTableViewCell: UITableViewCell {
    // MARK: - Properties
    weak var delegate: FoodTableViewCellDelegate?
    
    private lazy var mainStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [productImageView, productInfoStackView, selectProductStackView])
        stackView.spacing = 12
        stackView.alignment = .center
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.layoutMargins = UIEdgeInsets(top: 16, left: 10, bottom: 16, right: 10)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let productImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var productInfoStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [productTitleLabel, productPriceLabel])
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.spacing = 12
        return stackView
    }()
    
    private let productTitleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .white
        label.numberOfLines = 1
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        return label
    }()
    
    private let productPriceLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()
    
    private lazy var selectProductStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [subtractProductButton, selectedQuantityLabel, addProductButton])
        stackView.alignment = .center
        stackView.spacing = 8
        return stackView
    }()
    
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
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
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
            
            productImageView.widthAnchor.constraint(equalToConstant: 80),
            productImageView.heightAnchor.constraint(equalToConstant: 80),
            
            selectedQuantityLabel.widthAnchor.constraint(equalToConstant: 24),
            subtractProductButton.widthAnchor.constraint(equalTo: subtractProductButton.heightAnchor),
            addProductButton.widthAnchor.constraint(equalTo: addProductButton.heightAnchor),
            subtractProductButton.widthAnchor.constraint(equalToConstant: 24),
            addProductButton.widthAnchor.constraint(equalToConstant: 24)
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
        backgroundColor = .customBackgroundColor
    }
}
