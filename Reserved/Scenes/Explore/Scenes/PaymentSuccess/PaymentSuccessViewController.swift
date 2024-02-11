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
    private let viewModel = PaymentSuccessViewModel()
    
    private var selectedProducts: [FoodItem]
    private let selectedRestaurant: Restaurant
    private var selectedDate: String
    private var selectedTime: String
    private var selectedGuests: Int
    
    private var timer: Timer?
    private var isSpinning = false
    private var finalIndex: Int = 0
    private var giftItem: FoodItem?
    
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
        label.font = UIFont.systemFont(ofSize: 16)
        label.text = "We are waiting for you in \(selectedRestaurant.name.capitalized)"
        label.numberOfLines = 0
        label.textColor = .white
        return label
    }()
    
    private lazy var successDateInfoLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.text = "at \(selectedDate), \(selectedTime)"
        label.numberOfLines = 0
        label.textColor = .white
        return label
    }()
    
    private let giftLabel: UILabel = {
        let label = UILabel()
        label.text = "We have a gift for you, tap a gift to open"
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
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
        viewModel.fetchFoodItems(for: selectedRestaurant)
        setup()
        setupAnimationView()
    }
    
    // MARK: - Methods
    private func setup() {
        setupViewModelDelegate()
        setupBackground()
        setupSubviews()
        setupConstraints()
        setupCollectionView()
    }
    
    private func setupViewModelDelegate() {
        viewModel.delegate = self
    }
    
    private func setupBackground() {
        view.backgroundColor = .customBackgroundColor
    }
    
    private func setupSubviews() {
        view.addSubview(mainStackView)
        mainStackView.addArrangedSubview(successLabel)
        mainStackView.addArrangedSubview(successInfoStackView)
        mainStackView.addArrangedSubview(giftLabel)
        mainStackView.addArrangedSubview(collectionView)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            mainStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            mainStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            mainStackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            mainStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            collectionView.heightAnchor.constraint(equalToConstant: 160)
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
            animationView.widthAnchor.constraint(equalToConstant: 200),
            animationView.heightAnchor.constraint(equalToConstant: 200),
        ])
        animationView.play()
        
        let tapMeLabel = UILabel()
        tapMeLabel.text = "Tap Me"
        tapMeLabel.textColor = .white
        tapMeLabel.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        tapMeLabel.textAlignment = .center
        mainStackView.addArrangedSubview(tapMeLabel)
        
        NSLayoutConstraint.activate([
            tapMeLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            tapMeLabel.topAnchor.constraint(equalTo: animationView.bottomAnchor, constant: -12)
        ])
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(animationViewDidTap))
        animationView.isUserInteractionEnabled = true
        animationView.addGestureRecognizer(tapGesture)
    }
    
    private func setupCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(RandomFoodCollectionViewCell.self, forCellWithReuseIdentifier: "randomFoodCollectionViewCell")
    }
    
    private func spinCollectionView() {
        let currentOffset = collectionView.contentOffset.x
        let nextOffset = currentOffset + 20
        if nextOffset >= collectionView.contentSize.width - collectionView.bounds.width {
            collectionView.contentOffset = CGPoint(x: 0, y: 0)
        } else {
            collectionView.setContentOffset(CGPoint(x: nextOffset, y: 0), animated: false)
        }
    }
    
    private func startCollectionViewSpinning() {
        let scrollSpeed: TimeInterval = 0.01
        timer = Timer.scheduledTimer(withTimeInterval: scrollSpeed, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            self.spinCollectionView()
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) { [weak self] in
            self?.stopSpinningAndHighlightItem()
        }
    }
    
    private func stopSpinningAndHighlightItem() {
        timer?.invalidate()
        timer = nil
        isSpinning = false
        
        finalIndex = Int.random(in: 0..<viewModel.foodItems!.count)
        giftItem = viewModel.foodItems?[finalIndex]
        
        let indexPath = IndexPath(row: finalIndex, section: 0)
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { [weak self] in
            guard let self = self, let cell = self.collectionView.cellForItem(at: indexPath) as? RandomFoodCollectionViewCell else { return }
            
            UIView.animate(withDuration: 0.5, animations: {
                cell.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
            }) { _ in
                UIView.animate(withDuration: 0.5) {
                    cell.transform = CGAffineTransform.identity
                    self.navigateToGiftDetailViewController()
                    self.saveOrder()
                }
            }
        }
    }
    
    private func navigateToGiftDetailViewController() {
        guard let giftItem = giftItem else { return }
        let giftDetailViewController = GiftDetailViewController()
        giftDetailViewController.configure(with: giftItem)
        navigationController?.pushViewController(giftDetailViewController, animated: true)
    }
    
    private func saveOrder() {
        ReservationManager.shared.storeReservation(
            restaurantName: selectedRestaurant.name,
            reservationDate: selectedDate,
            reservationTime: selectedTime,
            guestsCount: selectedGuests,
            foodItems: selectedProducts,
            gift: giftItem)
    }
    
    // MARK: - Actions
    @objc private func animationViewDidTap() {
        if isSpinning { return }
        isSpinning = true
        animationView.stop()
        startCollectionViewSpinning()
    }
}

// MARK: - Extension: UICollectionViewDataSource
extension PaymentSuccessViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.foodItems?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard
            let foodItem = viewModel.foodItems?[indexPath.row],
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "randomFoodCollectionViewCell", for: indexPath) as? RandomFoodCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.configure(with: foodItem)
        return cell
    }
}

// MARK:  Extension: UICollectionViewDelegateFlowLayout
extension PaymentSuccessViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = Int((collectionView.bounds.width) / 2.5)
        let height = 160
        return CGSize(width: width, height: height)
    }
}

// MARK:  Extension: PaymentSuccessViewModelDelegate
extension PaymentSuccessViewController: PaymentSuccessViewModelDelegate {
    func fetchedFood(_ foodItems: [FoodItem]) {
        DispatchQueue.main.async {
            self.viewModel.foodItems = foodItems
            self.collectionView.reloadData()
        }
    }
    
    func showError(_ receivedError: Error) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "Error", message: receivedError.localizedDescription, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            self.present(alert, animated: true)
        }
    }
}
