//
//  GiftDetailViewController.swift
//  Reserved
//
//  Created by Ani's Mac on 10.02.24.
//

import UIKit

final class GiftDetailViewController: UIViewController {
    // MARK: - Properties
    var giftItem: FoodItem?
    
    private let mainStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 32
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var congratsStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [congratsLabel, congratsMessage])
        stackView.axis = .vertical
        stackView.spacing = 12
        stackView.alignment = .center
        return stackView
    }()
    
    private let congratsLabel: UILabel = {
        let label = UILabel()
        label.text = "🥳 Congrats!"
        label.font = UIFont.systemFont(ofSize: 24, weight: .medium)
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()
    
    private let congratsMessage: UILabel = {
        let label = UILabel()
        label.text = "Your gift awaits upon your arrival"
        label.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()
    
    private lazy var giftStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [giftImageView, giftNameLabel])
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.alignment = .center
        stackView.backgroundColor = .customSecondaryColor
        stackView.layer.cornerRadius = 10
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.layoutMargins = UIEdgeInsets(top: 24, left: 24, bottom: 24, right: 24)
        return stackView
    }()
    
    private let giftImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let giftNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()
    
    private lazy var returnButton: UIButton = {
        let button = MainButtonComponent(
            text: "Return to Homepage",
            textColor: UIColor.white,
            backgroundColor: UIColor.customAccentColor
        )
        button.addTarget(self, action: #selector(returnButtonDidTap), for: .touchUpInside)
        return button
    }()
    
    // MARK: - ViewLifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        hideBackButton()
        setup()
        configureViews()
    }
    
    // MARK: - Methods
    func configure(with giftItem: FoodItem) {
        self.giftItem = giftItem
    }
    
    private func hideBackButton() {
        navigationItem.setHidesBackButton(true, animated: false)
    }
    
    private func setup() {
        setupBackground()
        setupSubviews()
        setupConstraints()
    }
    
    private func setupBackground() {
        view.backgroundColor = .customBackgroundColor
    }
    
    private func setupSubviews() {
        view.addSubview(mainStackView)
        mainStackView.addArrangedSubview(congratsStackView)
        mainStackView.addArrangedSubview(giftStackView)
        mainStackView.addArrangedSubview(returnButton)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            mainStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            mainStackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            mainStackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            giftImageView.widthAnchor.constraint(equalToConstant: 180),
            giftImageView.heightAnchor.constraint(equalToConstant: 180)
        ])
    }
    
    private func configureViews() {
        guard let giftItem = giftItem else { return }
        if let imageUrl = giftItem.image {
            setImage(from: imageUrl)
        }
        giftNameLabel.text = giftItem.name
    }
    
    private func setImage(from url: String) {
        NetworkManager.shared.downloadImage(from: url) { [weak self] image in
            DispatchQueue.main.async {
                self?.giftImageView.image = image
            }
        }
    }
    
    // MARK: - Actions
    @objc private func returnButtonDidTap() {
        self.navigationController?.popToRootViewController(animated: true)
    }
}

