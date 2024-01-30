//
//  ProfileViewController.swift
//  Reserved
//
//  Created by Ani's Mac on 18.01.24.
//

import UIKit

final class ProfileViewController: UIViewController {
    // MARK: - Properties
    private let mainStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 40
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.layoutMargins = UIEdgeInsets(top: 24, left: 16, bottom: 24, right: 16)
        return stackView
    }()
    
    private lazy var gamificationStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [missionLabel, badgeImage, progressView, progressStartEndLabelsStackView])
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.backgroundColor = .customSecondaryColor
        stackView.layer.cornerRadius = 12
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.layoutMargins = UIEdgeInsets(top: 16, left: 24, bottom: 16, right: 24)
        return stackView
    }()

    private let missionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        label.numberOfLines = 0
        label.textColor = .white
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 8
        
        let attributedText = NSMutableAttributedString(string: "Reserve and unlock exclusive discounts just for you 🏆")
        attributedText.addAttribute(
            NSAttributedString.Key.paragraphStyle,
            value: paragraphStyle,
            range: NSMakeRange(0, attributedText.length)
        )
        label.attributedText = attributedText
        label.textAlignment = .center
        return label
    }()
    
    private let badgeImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "Badge")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var progressView: UIProgressView = {
        let progressView = UIProgressView()
        progressView.progress = 0
        progressView.progressViewStyle = .bar
        progressView.progressTintColor = .customAccentColor
        progressView.backgroundColor = .white
        progressView.layer.cornerRadius = 3
        return progressView
    }()
    
    private lazy var progressStartEndLabelsStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [startLabel, endLabel])
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        return stackView
    }()

    private let startLabel: UILabel = {
        let label = UILabel()
        label.text = "0"
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.textColor = .white.withAlphaComponent(0.8)
        return label
    }()

    private let endLabel: UILabel = {
        let label = UILabel()
        label.text = "10"
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.textColor = .white
        return label
    }()
    
    private let avatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "Avatar")
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .white
        return imageView
    }()
    
    private lazy var userInfoStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [personalDetailsAndChevronStackView, favoritesStackView, reservationsStackView])
        stackView.axis = .vertical
        stackView.spacing = 24
        stackView.distribution = .equalSpacing
        return stackView
    }()
    
    private lazy var personalDetailsAndChevronStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [personalDetailsStackView, chevronImageView])
        stackView.distribution = .equalSpacing
        stackView.isUserInteractionEnabled = true
        return stackView
    }()
    
    private lazy var personalDetailsStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [personalDetailsIcon, personalDetailsLabel])
        stackView.spacing = 12
        return stackView
    }()
    
    private let personalDetailsIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "person")
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .white
        return imageView
    }()
    
    private let personalDetailsLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        label.text = "Personal Details"
        label.textColor = .white
        return label
    }()
    
    private let chevronImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "chevron.right")
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .white
        return imageView
    }()
    
    private lazy var favoritesStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [favoritesIcon, favoritesLabel])
        stackView.spacing = 12
        return stackView
    }()
    
    private let favoritesIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "heart")
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .white
        return imageView
    }()
    
    private let favoritesLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        label.textColor = .white
        return label
    }()
    
    private lazy var reservationsStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [reservationsIcon, reservationsLabel])
        stackView.spacing = 12
        return stackView
    }()
    
    private let reservationsIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "circle.fill")
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .green
        return imageView
    }()
    
    private let reservationsLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        label.text = "Active Reservations"
        label.textColor = .white
        return label
    }()
    
    private lazy var signOutButton: MainButtonComponent = {
        let button = MainButtonComponent(
            text: "Sign out",
            textColor: .white,
            backgroundColor: .customAccentColor
        )
        return button
    }()

    // MARK: - ViewLifeCycles
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        FavoritesManager.shared.delegate = self
        updateFavoritesLabel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateFavoritesLabel()
    }
    
    // MARK: - Methods
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
        mainStackView.addArrangedSubview(avatarImageView)

        mainStackView.addArrangedSubview(gamificationStackView)

        mainStackView.addArrangedSubview(userInfoStackView)
        mainStackView.addArrangedSubview(signOutButton)

    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            mainStackView.topAnchor.constraint(equalTo: view.topAnchor),
            mainStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mainStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            mainStackView.bottomAnchor.constraint(lessThanOrEqualTo: view.bottomAnchor),
           
            avatarImageView.heightAnchor.constraint(equalToConstant: 100),
            avatarImageView.widthAnchor.constraint(equalToConstant: 100),
            
            reservationsIcon.heightAnchor.constraint(equalToConstant: 12),
            reservationsIcon.widthAnchor.constraint(equalToConstant: 12),
            
            badgeImage.heightAnchor.constraint(equalToConstant: 80),
            badgeImage.widthAnchor.constraint(equalToConstant: 80),
            
            progressView.heightAnchor.constraint(equalToConstant: 6),
                
        ])
    }
    
    private func updateFavoritesLabel() {
        let count = FavoritesManager.shared.favoriteRestaurants.count
        favoritesLabel.text = "Favorites: \(count)"
    }
}

#Preview {
    ProfileViewController()
}

extension ProfileViewController: FavoritesManagerDelegate {
    func favoritesManagerDidUpdateFavorites() {
        updateFavoritesLabel()
    }
}
