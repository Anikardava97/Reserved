//
//  OrderFoodViewController.swift
//  Reserved
//
//  Created by Ani's Mac on 05.02.24.
//

import UIKit

final class OrderFoodViewController: UIViewController {
    // MARK: - Properties
    let viewModel = OrderFoodViewModel()
    var selectedRestaurant: Restaurant?
    var selectedDate: String?
    var selectedTime: String?
    var selectedGuests: Int?
    
    private let mainStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.spacing = 24
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let headerLabel: UILabel = {
        let label = UILabel()
        label.text = "Save time with advance orders"
        label.textColor = .white
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        return label
    }()
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.sectionInset = .zero
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.isPagingEnabled = true
        return collectionView
    }()
    
    private lazy var checkoutStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [totalPriceLabel, checkoutButton])
        stackView.distribution = .equalSpacing
        return stackView
    }()
    
    private let totalPriceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Total Price :  0.0 $"
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        label.textAlignment = .center
        return label
    }()
    
    private lazy var checkoutButton: MainButtonComponent = {
        let button = MainButtonComponent(
            text: "Checkout",
            textColor: .white,
            backgroundColor: .customAccentColor
        )
        button.addTarget(self, action: #selector(checkoutButtonDidTap), for: .touchUpInside)
        return button
    }()
    
    private var tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .clear
        tableView.showsVerticalScrollIndicator = false
        return tableView
    }()
    
    private lazy var viewToggleSegmentedControl: UISegmentedControl = {
        let segmentedControl = UISegmentedControl(items: ["Details", "List"])
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.tintColor = .customSecondaryColor
        segmentedControl.selectedSegmentTintColor = .customAccentColor
        segmentedControl.addTarget(self, action: #selector(toggleView(_:)), for: .valueChanged)
        
        segmentedControl.setImage(UIImage(systemName: "list.bullet.below.rectangle"), forSegmentAt: 0)
        segmentedControl.setImage(UIImage(systemName: "list.bullet"), forSegmentAt: 1)
        
        let normalTextAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.white.withAlphaComponent(0.8),
            .font: UIFont.systemFont(ofSize: 16)
        ]
        let selectedTextAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.white,
            .font: UIFont.boldSystemFont(ofSize: 16)
        ]
        
        segmentedControl.setTitleTextAttributes(normalTextAttributes, for: .normal)
        segmentedControl.setTitleTextAttributes(selectedTextAttributes, for: .selected)
        return segmentedControl
    }()
    
    // MARK: - ViewLifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let selectedRestaurant = selectedRestaurant else { return }
        viewModel.fetchFoodItems(for: selectedRestaurant)
        hideBackButton()
        setup()
        updateCheckoutButtonState()
    }
    
    // MARK: - Private Methods
    private func hideBackButton() {
        navigationItem.setHidesBackButton(true, animated: false)
    }
    
    private func setup() {
        setupViewModelDelegate()
        setupBackground()
        setupSubviews()
        setupConstraints()
        setupCollectionView()
        setupTableView()
    }
    
    private func setupViewModelDelegate() {
        viewModel.delegate = self
    }
    
    private func setupBackground() {
        view.backgroundColor = .customBackgroundColor
    }
    
    private func setupSubviews() {
        view.addSubview(mainStackView)
        mainStackView.addArrangedSubview(headerLabel)
        mainStackView.addArrangedSubview(viewToggleSegmentedControl)
        mainStackView.addArrangedSubview(collectionView)
        mainStackView.addArrangedSubview(tableView)
        mainStackView.addArrangedSubview(checkoutStackView)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            mainStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            mainStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            mainStackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            mainStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            
            checkoutButton.widthAnchor.constraint(equalToConstant: 140),
            viewToggleSegmentedControl.trailingAnchor.constraint(equalTo: mainStackView.trailingAnchor, constant: -220),
            viewToggleSegmentedControl.heightAnchor.constraint(equalToConstant: 44)
        ])
    }
    
    private func setupCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(FoodCollectionViewCell.self, forCellWithReuseIdentifier: "foodItemsCollectionViewCell")
    }
    
    private func setupTableView() {
        tableView.isHidden = true
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(FoodTableViewCell.self, forCellReuseIdentifier: "foodItemsTableViewCell")
    }
    
    private func updateCheckoutButtonState() {
        let totalPrice = viewModel.totalPrice ?? 0
        checkoutButton.isEnabled = totalPrice > 0
        checkoutButton.backgroundColor = totalPrice > 0 ? .customAccentColor : .customAccentColor.withAlphaComponent(0.6)
        if checkoutButton.isEnabled {
            checkoutButton.setTitleColor(.white, for: .normal)
        } else {
            checkoutButton.setTitleColor(.white.withAlphaComponent(0.6), for: .disabled)
        }
    }
    
    // MARK: - Actions
    @objc private func checkoutButtonDidTap() {
        guard let selectedProducts = viewModel.foodItems,
              let selectedRestaurant = selectedRestaurant else { return }
        let selectedDate = selectedDate ?? ""
        let selectedTime = selectedTime ?? ""
        let selectedGuests = selectedGuests ?? 0
        let totalPrice = viewModel.totalPrice ?? 0
        let checkoutViewController = CheckoutViewController(
            selectedProducts: selectedProducts,
            selectedRestaurant: selectedRestaurant,
            selectedDate: selectedDate,
            selectedTime: selectedTime,
            selectedGuests: selectedGuests,
            totalPrice: totalPrice)
        self.navigationController?.pushViewController(checkoutViewController, animated: true)
    }
    
    @objc private func toggleView(_ sender: UISegmentedControl) {
        collectionView.isHidden = sender.selectedSegmentIndex != 0
        tableView.isHidden = sender.selectedSegmentIndex == 0
    }
}

// MARK: - Extension: UICollectionViewDataSource
extension OrderFoodViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.foodItems?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard
            let foodItem = viewModel.foodItems?[indexPath.row],
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "foodItemsCollectionViewCell", for: indexPath) as? FoodCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.delegate = self
        cell.configure(with: foodItem)
        return cell
    }
}

// MARK:  Extension: UICollectionViewDelegateFlowLayout
extension OrderFoodViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.bounds.width
        let height = collectionView.bounds.height
        return CGSize(width: width, height: height)
    }
}

// MARK:  Extension: FoodCollectionViewCellDelegate
extension OrderFoodViewController: FoodCollectionViewCellDelegate {
    func addProduct(for cell: FoodCollectionViewCell?) {
        if let indexPath = collectionView.indexPath(for: cell!) {
            viewModel.addProduct(at: indexPath.row)
            
            if let updatedInfo = viewModel.foodItems?[indexPath.row] {
                cell?.updateQuantityLabel(with: updatedInfo)
            }
        }
    }
    
    func removeProduct(for cell: FoodCollectionViewCell?) {
        if let indexPath = collectionView.indexPath(for: cell!) {
            viewModel.removeProduct(at: indexPath.row)
            
            if let updatedInfo = viewModel.foodItems?[indexPath.row] {
                cell?.updateQuantityLabel(with: updatedInfo)
            }
        }
    }
}

// MARK: - Extension: UITableViewDataSource
extension OrderFoodViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.foodItems?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "foodItemsTableViewCell", for: indexPath) as? FoodTableViewCell,
              let foodItem = viewModel.foodItems?[indexPath.row] else {
            return UITableViewCell()
        }
        cell.delegate = self
        cell.configure(with: foodItem)
        return cell
    }
}

// MARK:  Extension: TableViewDelegate
extension OrderFoodViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
}

// MARK:  Extension: FoodTableViewCellDelegate
extension OrderFoodViewController: FoodTableViewCellDelegate {
    func addProduct(for cell: FoodTableViewCell?) {
        if let indexPath = tableView.indexPath(for: cell!) {
            viewModel.addProduct(at: indexPath.row)
            
            if let updatedInfo = viewModel.foodItems?[indexPath.row] {
                cell?.updateQuantityLabel(with: updatedInfo)
            }
        }
    }
    
    func removeProduct(for cell: FoodTableViewCell?) {
        if let indexPath = tableView.indexPath(for: cell!) {
            viewModel.removeProduct(at: indexPath.row)
            
            if let updatedInfo = viewModel.foodItems?[indexPath.row] {
                cell?.updateQuantityLabel(with: updatedInfo)
            }
        }
    }
}

// MARK: - Extension: OrderFoodViewModelDelegate
extension OrderFoodViewController: OrderFoodViewModelDelegate {
    func fetchedFood(_ foodItems: [FoodItem]) {
        DispatchQueue.main.async {
            self.viewModel.foodItems = foodItems
            self.collectionView.reloadData()
            self.tableView.reloadData()
        }
    }
    
    func showError(_ receivedError: Error) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "Error", message: receivedError.localizedDescription, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            self.present(alert, animated: true)
        }
    }
    
    func productsAmountChanged() {
        DispatchQueue.main.async {
            self.updateCheckoutButtonState()
            self.totalPriceLabel.text = "Total Price :  \(self.viewModel.totalPrice ?? 0) $"
            self.collectionView.reloadData()
            self.tableView.reloadData()
        }
    }
}
