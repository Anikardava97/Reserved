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
    
    private let mainStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.spacing = 18
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let totalPriceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Total: 0$"
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 20, weight: .medium)
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
    
    // MARK: - ViewLifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.viewDidLoad()
        setup()
    }
    
    // MARK: - Private Methods
    private func setup() {
        setupViewModelDelegate()
        setupBackground()
        setupCollectionView()
        setupSubviews()
        setupConstraints()
    }
    
    private func setupViewModelDelegate() {
        viewModel.delegate = self
    }
    
    private func setupBackground() {
        view.backgroundColor = .customBackgroundColor
    }
    
    private func setupCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(FoodCollectionViewCell.self, forCellWithReuseIdentifier: "foodItemsCell")
    }
    
    private func setupSubviews() {
        view.addSubview(mainStackView)
        mainStackView.addArrangedSubview(collectionView)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            mainStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            mainStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            mainStackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            mainStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
        ])
    }
    
    private func setupTotalPriceLabel() {
        view.addSubview(totalPriceLabel)
        
        NSLayoutConstraint.activate([
            totalPriceLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            totalPriceLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            totalPriceLabel.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
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
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "foodItemsCell", for: indexPath) as? FoodCollectionViewCell else {
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

extension OrderFoodViewController: FoodCellDelegate {
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

extension OrderFoodViewController: OrderFoodViewModelDelegate {
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

    func productsAmountChanged() {
        totalPriceLabel.text = "Total price: \(viewModel.totalPrice ?? 0) $"
    }
}

#Preview {
    OrderFoodViewController()
}
