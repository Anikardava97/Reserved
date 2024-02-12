//
//  ProfileViewController.swift
//  Reserved
//
//  Created by Ani's Mac on 18.01.24.
//

import UIKit

final class ProfileViewController: UIViewController {
    // MARK: - Properties
    private let maxReservationsForFullProgress = 10
    
    private let mainStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 24
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
        progressView.layer.masksToBounds = true
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
    
    private lazy var userInfoStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [personalDetailsStackView, favoritesStackView, reservationsStackView])
        stackView.axis = .vertical
        stackView.spacing = 24
        stackView.distribution = .equalSpacing
        stackView.backgroundColor = .customSecondaryColor
        stackView.layoutMargins = UIEdgeInsets(top: 16, left: 24, bottom: 16, right: 24)
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.layer.cornerRadius = 10
        return stackView
    }()
    
    private lazy var personalDetailsStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [personalDetailsIcon, personalDetailsLabel, UIView()])
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
        let email = AuthenticationManager.shared.getCurrentUserEmail() ?? "Email not available"
        label.text = "Email: \(email)"
        label.textColor = .white
        return label
    }()
    
    private lazy var favoritesStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [favoritesIcon, favoritesLabel, UIView()])
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
        let stackView = UIStackView(arrangedSubviews: [reservationsIcon, reservationsLabel, UIView()])
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
        label.textColor = .white
        return label
    }()
    
    private lazy var creditCardsAndOrdersStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [creditCardsStackView, myOrdersStackView])
        stackView.axis = .vertical
        stackView.spacing = 24
        return stackView
    }()
    
    private lazy var creditCardsStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [creditCardsIcon, creditCardsLabel, UIView(), myCardsChevronImageView])
        stackView.spacing = 12
        stackView.backgroundColor = .customSecondaryColor
        stackView.layoutMargins = UIEdgeInsets(top: 16, left: 24, bottom: 16, right: 24)
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.layer.cornerRadius = 10
        
        let creditCardsTapGesture = UITapGestureRecognizer(target: self, action: #selector(creditCardsStackViewDidTap))
        stackView.isUserInteractionEnabled = true
        stackView.addGestureRecognizer(creditCardsTapGesture)
        return stackView
    }()
    
    private let creditCardsIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "creditcard")
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .white
        return imageView
    }()
    
    private let creditCardsLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        label.text = "My Credit Cards"
        label.textColor = .white
        return label
    }()
    
    private let myCardsChevronImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "chevron.right")
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .white
        return imageView
    }()
    
    private lazy var myOrdersStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [myOrdersIcon, myOrdersLabel, UIView(), myOrdersChevronImageView])
        stackView.spacing = 12
        stackView.backgroundColor = .customSecondaryColor
        stackView.layoutMargins = UIEdgeInsets(top: 16, left: 24, bottom: 16, right: 24)
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.layer.cornerRadius = 10
        
        let myOrdersTapGesture = UITapGestureRecognizer(target: self, action: #selector(myOrdersStackViewDidTap))
        stackView.isUserInteractionEnabled = true
        stackView.addGestureRecognizer(myOrdersTapGesture)
        return stackView
    }()
    
    private let myOrdersIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "wineglass")
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .white
        return imageView
    }()
    
    private let myOrdersLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        label.text = "My Orders"
        label.textColor = .white
        return label
    }()
    
    private let myOrdersChevronImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "chevron.right")
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .white
        return imageView
    }()
    
    private lazy var signOutButton: MainButtonComponent = {
        let button = MainButtonComponent(
            text: "Sign out",
            textColor: .white,
            backgroundColor: .customAccentColor
        )
        button.addTarget(self, action: #selector(signOutDidTap), for: .touchUpInside)
        return button
    }()
    
    // MARK: - ViewLifeCycles
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        updateFavoritesLabel()
        updateReservationsLabel()
        updateProgressView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateFavoritesLabel()
        updateReservationsLabel()
        updateProgressView()
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
        mainStackView.addArrangedSubview(userInfoStackView)
        mainStackView.addArrangedSubview(creditCardsAndOrdersStackView)
        mainStackView.addArrangedSubview(gamificationStackView)
        mainStackView.addArrangedSubview(signOutButton)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            mainStackView.topAnchor.constraint(equalTo: view.topAnchor),
            mainStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mainStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            mainStackView.bottomAnchor.constraint(lessThanOrEqualTo: view.bottomAnchor),
            
            reservationsIcon.heightAnchor.constraint(equalToConstant: 12),
            reservationsIcon.widthAnchor.constraint(equalToConstant: 12),
            
            badgeImage.heightAnchor.constraint(equalToConstant: 80),
            badgeImage.widthAnchor.constraint(equalToConstant: 80),
            
            progressView.heightAnchor.constraint(equalToConstant: 6)
        ])
    }
    
    private func updateFavoritesLabel() {
        let count = FavoritesManager.shared.favoriteRestaurants.count
        favoritesLabel.text = "Favorites: \(count)"
    }
    
    private func updateReservationsLabel() {
        let count = ReservationManager.shared.myReservations.count
        reservationsLabel.text = "Active Reservations: \(count)"
    }
    
    private func updateProgressView() {
        let currentReservationsCount = ReservationManager.shared.myReservations.count
        let progress = min(Float(currentReservationsCount) / Float(maxReservationsForFullProgress), 1.0)
        progressView.setProgress(progress, animated: true)
    }
    
    private func confirmSignOut() {
        do {
            try AuthenticationManager.shared.signOut()
            NavigationManager.shared.showLaunchScreen()
        } catch {
            print("Error signing out: \(error)")
        }
    }
    
    // MARK: - Actions
    @objc private func signOutDidTap() {
        let alert = UIAlertController(title: "Sign Out", message: "Are you sure you want to sign out?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Sign Out", style: .destructive, handler: { [weak self] _ in
            self?.confirmSignOut()
        }))
        present(alert, animated: true)
    }
    
    @objc private func creditCardsStackViewDidTap() {
        let creditCardsViewController = MyCreditCardsViewController()
        navigationController?.pushViewController(creditCardsViewController, animated: true)
    }
    
    @objc private func myOrdersStackViewDidTap() {
        let myOrdersViewController = MyOrdersViewController()
        navigationController?.pushViewController(myOrdersViewController, animated: true)
    }
}




