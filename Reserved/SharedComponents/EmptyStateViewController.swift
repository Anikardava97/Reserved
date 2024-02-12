//
//  EmptyStateViewController.swift
//  Reserved
//
//  Created by Ani's Mac on 28.01.24.
//

import UIKit
import Lottie

class EmptyStateViewController: UIViewController {
    // MARK: - Properties
    private var animationView: LottieAnimationView!
    
    private let emptyStateStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 24
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let emptyStateTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        label.textColor = .white
        return label
    }()
    
    private let paragraphStyle: NSMutableParagraphStyle = {
        let style = NSMutableParagraphStyle()
        style.lineSpacing = 8
        style.alignment = .center
        return style
    }()
    
    private lazy var emptyStateDescriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.numberOfLines = 0
        label.textColor = .white
        
        let attributedText = NSMutableAttributedString(string: "")
        attributedText.addAttribute(
            NSAttributedString.Key.paragraphStyle,
            value: paragraphStyle,
            range: NSMakeRange(0, attributedText.length)
        )
        label.attributedText = attributedText
        return label
    }()
    
    private lazy var exploreButton: MainButtonComponent = {
        let button = MainButtonComponent(text: "Explore", textColor: .white, backgroundColor: .customAccentColor)
        button.addTarget(self, action: #selector(exploreButtonDidTap), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Init
    init(title: String, description: String, animationName: String) {
        super.init(nibName: nil, bundle: nil)
        emptyStateTitleLabel.text = title
        let attributedText = NSMutableAttributedString(string: description)
        attributedText.addAttribute(
            NSAttributedString.Key.paragraphStyle,
            value: paragraphStyle,
            range: NSMakeRange(0, attributedText.length)
        )
        emptyStateDescriptionLabel.attributedText = attributedText
        setupEmptyHistoryAnimationView(animationName)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - ViewLifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
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
        view.addSubview(emptyStateStackView)
        emptyStateStackView.addArrangedSubview(emptyStateTitleLabel)
        emptyStateStackView.addArrangedSubview(emptyStateDescriptionLabel)
        emptyStateStackView.addArrangedSubview(exploreButton)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            emptyStateStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            emptyStateStackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            emptyStateStackView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 60),
            exploreButton.leadingAnchor.constraint(equalTo: emptyStateStackView.leadingAnchor),
            exploreButton.trailingAnchor.constraint(equalTo: emptyStateStackView.trailingAnchor),
        ])
    }
    
    private func setupEmptyHistoryAnimationView(_ animationName: String) {
        animationView = .init(name: animationName)
        let animationViewSize = CGSize(width: 240, height: 240)
        
        animationView.frame = CGRect(
            x: (view.frame.width - animationViewSize.width) / 2,
            y: (view.frame.height - animationViewSize.height) / 2 - 120,
            width: animationViewSize.width,
            height: animationViewSize.height
        )
        animationView.contentMode = .scaleAspectFit
        animationView.loopMode = .loop
        animationView.animationSpeed = 0.5
        view.addSubview(animationView)
        animationView.play()
    }
    
    // MARK: - Actions
    @objc private func exploreButtonDidTap() {
        if let tabBarController = self.tabBarController {
            tabBarController.selectedIndex = 0
        }
    }
}
