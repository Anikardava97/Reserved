//
//  MyCreditCardsTableViewCell.swift
//  Reserved
//
//  Created by Ani's Mac on 10.02.24.
//

import UIKit

protocol MyCreditCardsTableViewCellDelegate: AnyObject {
    func removeCard(for cell: MyCreditCardsTableViewCell?)
}

final class MyCreditCardsTableViewCell: UITableViewCell {
    // MARK: - Properties
    weak var delegate: MyCreditCardsTableViewCellDelegate?

    private lazy var mainStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [cardInfoStackView, deleteCardImageView])
        stackView.spacing = 12
        stackView.alignment = .center
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.layoutMargins = UIEdgeInsets(top: 16, left: 10, bottom: 16, right: 16)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var cardInfoStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [cardNameLabel, cardNumberLabel])
        stackView.axis = .vertical
        stackView.spacing = 12
        stackView.alignment = .leading
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.layoutMargins = UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let cardNameLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .white
        label.numberOfLines = 1
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        return label
    }()
    
    private let cardNumberLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .white
        label.numberOfLines = 1
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        return label
    }()
    
    private lazy var deleteCardImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "trash.circle.fill")
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .white
        imageView.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(deleteCardDidTap))
        imageView.addGestureRecognizer(tapGesture)
        return imageView

    }()
    
    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        addSubview()
        setupConstraints()
        setupCellAppearance()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    // MARK: - CellLifeCycle
    override func prepareForReuse() {
        super.prepareForReuse()
        
        cardNameLabel.text = nil
        cardNumberLabel.text = nil
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
            
            deleteCardImageView.widthAnchor.constraint(equalToConstant: 32),
            deleteCardImageView.heightAnchor.constraint(equalToConstant: 32)
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
    
    @objc private func deleteCardDidTap() {
        delegate?.removeCard(for: self)
    }
    
    // MARK: - Configuration
    func configure(with card: CreditCard) {
        cardNameLabel.text = card.name
        cardNumberLabel.text = "**** **** **** \(card.number.suffix(4))"
        backgroundColor = .customBackgroundColor
    }
}

