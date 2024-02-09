//
//  CheckoutViewController.swift
//  Reserved
//
//  Created by Ani's Mac on 09.02.24.
//

import UIKit

final class CheckoutViewController: UIViewController {
    // MARK: - Properties
    private var selectedProducts: [FoodItem]
    private let selectedRestaurant: Restaurant
    let viewModel: CheckoutViewModel
    var newCardAdded = false
    
    private let mainStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.spacing = 16
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let headerLabel: UILabel = {
        let label = UILabel()
        label.text = "Your order"
        label.textColor = .white
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        return label
    }()
    
    private let headerContentTitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        return label
    }()
    
    private var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.backgroundColor = .clear
        tableView.showsVerticalScrollIndicator = false
        return tableView
    }()
    
    private let paymentMethodLabel: UILabel = {
        let label = UILabel()
        label.text = "Payment details"
        label.textColor = .white
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        return label
    }()
    
    private let paymentLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .white
        return label
    }()
    
    private let chevronImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .white
        imageView.widthAnchor.constraint(equalToConstant: 16).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 16).isActive = true
        return imageView
    }()
    
    private lazy var paymentStackView: UIStackView = {
        let iconImageView = UIImageView(image: UIImage(systemName: "creditcard"))
        iconImageView.contentMode = .scaleAspectFit
        iconImageView.tintColor = .white
        iconImageView.widthAnchor.constraint(equalToConstant: 24).isActive = true
        iconImageView.heightAnchor.constraint(equalToConstant: 24).isActive = true
        
        
        let iconLabelStackView = UIStackView(arrangedSubviews: [iconImageView, paymentLabel])
        iconLabelStackView.axis = .horizontal
        iconLabelStackView.spacing = 10
        iconLabelStackView.alignment = .center
        
        let stackView = UIStackView(arrangedSubviews: [iconLabelStackView, chevronImageView])
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.backgroundColor = .customSecondaryColor
        stackView.layer.cornerRadius = 10
        stackView.distribution = .equalSpacing
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.layoutMargins = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(paymentStackViewDidTap))
        stackView.addGestureRecognizer(tapGesture)
        return stackView
    }()
    
    private lazy var checkoutStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [summaryLabel, totalStackView, paymentButton])
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.layer.borderWidth = 2
        stackView.layer.borderColor = UIColor.customSecondaryColor.cgColor
        stackView.layer.cornerRadius = 10
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.layoutMargins = UIEdgeInsets(top: 16, left: 24, bottom: 16, right: 24)
        return stackView
    }()
    
    private let summaryLabel: UILabel = {
        let label = UILabel()
        label.text = "Summary"
        label.textColor = .white
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        return label
    }()
    
    private lazy var totalStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [totalPriceLabel, priceLabel])
        stackView.distribution = .equalSpacing
        return stackView
    }()
    
    private let totalPriceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Total"
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        label.textAlignment = .center
        return label
    }()
    
    private lazy var priceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "\(viewModel.totalPrice ?? 0) $"
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        label.textAlignment = .center
        return label
    }()
    
    private lazy var paymentButton: MainButtonComponent = {
        let button = MainButtonComponent(
            text: "Submit Payment",
            textColor: .white,
            backgroundColor: .customAccentColor
        )
        button.addTarget(self, action: #selector(paymentButtonDidTap), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Init
    init(selectedProducts: [FoodItem], selectedRestaurant: Restaurant, totalPrice: Double?) {
        self.selectedProducts = selectedProducts
        self.selectedRestaurant = selectedRestaurant
        self.viewModel = CheckoutViewModel(totalPrice: totalPrice)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.selectedProducts = selectedProducts.filter { $0.selectedAmount ?? 0 > 0 }
        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updatePaymentMethodDisplay()
        if newCardAdded {
            DispatchQueue.main.async { [weak self] in
                if let window = self?.view.window {
                    ConfirmationBanner.show(in: window, message: "Card added successfully")
                }
                self?.newCardAdded = false
            }
        }
    }
    
    // MARK: - Methods
    private func updatePaymentMethodDisplay() {
        let lastCard = viewModel.creditCardManager.cards.last
        if let card = lastCard {
            let lastFourDigits = String(card.number.suffix(4))
            paymentLabel.text = "**** **** **** \(lastFourDigits)"
            
            chevronImageView.image = UIImage(systemName: "chevron.down")
        } else {
            paymentLabel.text = "Add new card"
            chevronImageView.image = UIImage(systemName: "chevron.right")
        }
    }
    
    private func setup() {
        setupBackground()
        setupSubviews()
        setupConstraints()
        setupTableView()
        updateHeaderContentTitleLabel()
    }
    
    private func setupBackground() {
        view.backgroundColor = .customBackgroundColor
    }
    
    private func setupSubviews() {
        view.addSubview(mainStackView)
        mainStackView.addArrangedSubview(headerLabel)
        mainStackView.addArrangedSubview(headerContentTitleLabel)
        mainStackView.addArrangedSubview(tableView)
        mainStackView.addArrangedSubview(paymentMethodLabel)
        mainStackView.addArrangedSubview(paymentStackView)
        mainStackView.addArrangedSubview(checkoutStackView)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            mainStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            mainStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            mainStackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            mainStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16)
        ])
    }
    
    private func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(CheckoutTableViewCell.self, forCellReuseIdentifier: "checkoutTableViewCell")
    }
    
    private func updateHeaderContentTitleLabel() {
        let productCount = selectedProducts.reduce(0) { $0 + ($1.selectedAmount ?? 0) }
        let restaurantName = selectedRestaurant.name.uppercased()
        
        var text: String
        if productCount == 1 {
            text = "1 product awaits at  \(restaurantName)"
        } else {
            text = "\(productCount) products await at  \(restaurantName)"
        }
        
        let attributedString = NSMutableAttributedString(string: text)
        if let nameRange = text.range(of: restaurantName) {
            let nsRange = NSRange(nameRange, in: text)
            attributedString.addAttribute(.foregroundColor, value: UIColor.customAccentColor, range: nsRange)
        }
        headerContentTitleLabel.attributedText = attributedString
    }
    
    // MARK: - Actions
    @objc private func paymentStackViewDidTap() {
        let addCardViewController = AddCardViewController()
        addCardViewController.delegate = self
        navigationController?.pushViewController(addCardViewController, animated: true)
        addCardViewController.creditCardManager = self.viewModel.creditCardManager
    }
    
    @objc private func paymentButtonDidTap() {    }
}

// MARK:  Extension: UITableViewDataSource
extension CheckoutViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return selectedProducts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "checkoutTableViewCell", for: indexPath) as? CheckoutTableViewCell else { return UITableViewCell() }
        let product = selectedProducts[indexPath.row]
        cell.configure(with: product)
        return cell
    }
}

// MARK:  Extension: TableViewDelegate
extension CheckoutViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
}

// MARK:  Extension: AddCardViewControllerDelegate
extension CheckoutViewController: AddCardViewControllerDelegate {
    func didAddNewCard() {
        newCardAdded = true
    }
}
