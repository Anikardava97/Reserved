//
//  ConfirmationViewController.swift
//  Reserved
//
//  Created by Ani's Mac on 26.01.24.
//

import UIKit
import Lottie

class ConfirmationViewController: UIViewController {
    // MARK: - Properties
    var selectedRestaurant: Restaurant?
    var selectedDate: String?
    var selectedTime: String?
    var selectedGuests: Int?
    private var animationView: LottieAnimationView!
    
    private let mainStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.spacing = 20
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let successLabel: UILabel = {
        let label = UILabel()
        label.text = "🎉 Thank you for choosing us!"
        label.font = UIFont.systemFont(ofSize: 24, weight: .medium)
        label.numberOfLines = 0
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()
    
    private let reservationDetailsTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Your reservation details:"
        label.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        label.numberOfLines = 0
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()
    
    private func createSectionWrapperView() -> UIView {
        let view = UIView()
        view.backgroundColor = .darkGray.withAlphaComponent(0.1)
        view.layer.cornerRadius = 10
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }
    
    private lazy var detailsSectionView: UIView = {
        let view = createSectionWrapperView()
        
        let nameLabel = createLabelWithIcon(title: "Restaurant", value: selectedRestaurant?.name ?? "", iconName: "fork.knife")
        let dateLabel = createLabelWithIcon(title: "Date", value: selectedDate ?? "", iconName: "calendar")
        let timeLabel = createLabelWithIcon(title: "Time", value: selectedTime ?? "", iconName: "clock")
        let guestsLabel = createLabelWithIcon(title: "Guests", value: "\(selectedGuests ?? 0)", iconName: "person.2")
        
        let stackView = UIStackView(arrangedSubviews: [nameLabel, dateLabel, timeLabel, guestsLabel])
        stackView.axis = .vertical
        stackView.spacing = 24
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.topAnchor, constant: 24),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            stackView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -24)
        ])
        return view
    }()
    
    private func createLabelWithIcon(title: String, value: String, iconName: String) -> UIView {
        let containerView = UIView()
        
        let label = UILabel()
        label.text = "\(title) : \(value)"
        label.font = UIFont.systemFont(ofSize: 18)
        label.textColor = .white
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        
        if let systemIconImage = UIImage(systemName: iconName) {
            let iconImageView = UIImageView(image: systemIconImage)
            iconImageView.tintColor = .white
            iconImageView.contentMode = .scaleAspectFit
            iconImageView.translatesAutoresizingMaskIntoConstraints = false
            
            containerView.addSubview(iconImageView)
            containerView.addSubview(label)
            
            NSLayoutConstraint.activate([
                iconImageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
                iconImageView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
                iconImageView.widthAnchor.constraint(equalToConstant: 24),
                iconImageView.heightAnchor.constraint(equalToConstant: 24),
                
                label.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 12),
                label.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
                label.topAnchor.constraint(equalTo: containerView.topAnchor),
                label.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            ])
        }
        return containerView
    }
    
    private lazy var exploreButton: UIButton = {
        let button = MainButtonComponent(
            text: "Explore More",
            textColor: UIColor.white,
            backgroundColor: UIColor.customAccentColor
        )
        button.addTarget(self, action: #selector(exploreButtonDidTap), for: .touchUpInside)
        return button
    }()
    
    // MARK: - ViewLifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.setHidesBackButton(true, animated: false)
        setupLoaderAnimationView()
        view.backgroundColor = .customBackgroundColor
        DispatchQueue.main.asyncAfter(deadline: .now() + 6.0) { [weak self] in
            self?.animationView.stop()
            self?.animationView.isHidden = true
            self?.setup()
        }
    }
    // MARK: - Private Methods
    private func setup() {
        setupConfettiAnimationView()
        setupSubviews()
        setupConstraints()
    }
    
    private func setupLoaderAnimationView() {
        animationView = .init(name: "Animation - 1706348887513")
        let animationViewWidth: CGFloat = 100
        let animationViewHeight: CGFloat = 100
        
        animationView.frame = CGRect(
            x: (view.frame.width - animationViewWidth) / 2,
            y: (view.frame.height - animationViewHeight) / 2,
            width: animationViewWidth,
            height: animationViewHeight)
        
        animationView.contentMode = .scaleAspectFit
        animationView.loopMode = .loop
        animationView.animationSpeed = 0.6
        view.addSubview(animationView)
        animationView.play()
    }
    
    private func setupConfettiAnimationView() {
        animationView = .init(name: "Animation - 1706349327749")
        animationView.frame = view.frame.offsetBy(dx: 0, dy: -160)
        animationView.contentMode = .scaleAspectFit
        animationView.loopMode = .loop
        animationView.animationSpeed = 0.5
        view.addSubview(animationView)
        animationView.play()
    }
    
    private func setupSubviews() {
        view.addSubview(mainStackView)
        mainStackView.addArrangedSubview(successLabel)
        mainStackView.addArrangedSubview(reservationDetailsTitleLabel)
        mainStackView.addArrangedSubview(detailsSectionView)
        mainStackView.addArrangedSubview(exploreButton)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            mainStackView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 48),
            mainStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            mainStackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
        ])
    }
    
    @objc private func exploreButtonDidTap() {
        self.navigationController?.popToRootViewController(animated: true)
    }
}

#Preview {
    ConfirmationViewController()
}
