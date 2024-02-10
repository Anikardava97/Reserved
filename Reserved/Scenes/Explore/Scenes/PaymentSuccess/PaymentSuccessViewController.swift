//
//  PaymentSuccessViewController.swift
//  Reserved
//
//  Created by Ani's Mac on 09.02.24.
//

import UIKit
import Lottie

final class PaymentSuccessViewController: UIViewController {
    // MARK: - Properties
    private var animationView: LottieAnimationView!
    private var selectedProducts: [FoodItem]
    private let selectedRestaurant: Restaurant
    var selectedDate: String
    var selectedTime: String
    var selectedGuests: Int
    
    private let mainStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 24
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let successLabel: UILabel = {
        let label = UILabel()
        label.text = "🎉 Payment successful"
        label.font = UIFont.systemFont(ofSize: 24, weight: .medium)
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()
    
    private lazy var successInfoStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [successRestaurantInfoLabel, successDateInfoLabel])
        stackView.axis = .vertical
        stackView.spacing = 12
        stackView.alignment = .center
        stackView.backgroundColor = .customSecondaryColor
        stackView.layer.cornerRadius = 10
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.layoutMargins = UIEdgeInsets(top: 20, left: 24, bottom: 20, right: 24)
        return stackView
    }()
    
    private lazy var successRestaurantInfoLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18)
        label.text = "We are waiting for you in \(selectedRestaurant.name.uppercased())"
        label.numberOfLines = 0
        label.textColor = .white
        return label
    }()
    
    private lazy var successDateInfoLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18)
        label.text = "at \(selectedDate), \(selectedTime)"
        label.numberOfLines = 0
        label.textColor = .white
        return label
    }()
    
    private let giftLabel: UILabel = {
        let label = UILabel()
        label.text = "We have a gift for you!"
        label.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()
    
    // MARK: - Init
    init(selectedProducts: [FoodItem], selectedRestaurant: Restaurant, selectedDate: String, selectedTime: String, selectedGuests: Int) {
        self.selectedProducts = selectedProducts
        self.selectedRestaurant = selectedRestaurant
        self.selectedDate = selectedDate
        self.selectedTime = selectedTime
        self.selectedGuests = selectedGuests
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - ViewLifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.hidesBackButton = true
        setup()
        setupAnimationView()
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
        mainStackView.addArrangedSubview(successLabel)
        mainStackView.addArrangedSubview(successInfoStackView)
        mainStackView.addArrangedSubview(giftLabel)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            mainStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            mainStackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            mainStackView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    private func setupAnimationView() {
        animationView = .init(name: "Animation - 1707550934898")
        animationView.contentMode = .scaleAspectFit
        animationView.loopMode = .loop
        animationView.animationSpeed = 0.8
        animationView.translatesAutoresizingMaskIntoConstraints = false
        mainStackView.addArrangedSubview(animationView)
        
        NSLayoutConstraint.activate([
            animationView.widthAnchor.constraint(equalToConstant: 220),
            animationView.heightAnchor.constraint(equalToConstant: 220),
        ])
        animationView.play()
    }
}
