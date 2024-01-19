//
//  RestaurantsViewController.swift
//  Reserved
//
//  Created by Ani's Mac on 18.01.24.
//

import UIKit

class RestaurantsViewController: UIViewController {
    // MARK: - Properties
    private let viewModel = RestaurantsViewModel()
    private var restaurants = [Restaurant]()
    
    private let searchController = UISearchController(searchResultsController: nil)
    
    private let georgianCuisineButton = CuisineButton()
    private let europeanCuisineButton = CuisineButton()
    private let asianCuisineButton = CuisineButton()
    
    private let mainStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 20
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let cuisineStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 12
        return stackView
    }()
    
    private let cuisineLabel: UILabel = {
        let label = UILabel()
        label.text = "Cuisines"
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.textColor = .white
        return label
    }()
    
    private let cuisineButtonsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.distribution = .equalSpacing
        return stackView
    }()
    
    private let topRestaurantsLabel: UILabel = {
        let label = UILabel()
        label.text = "Top Restaurants"
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.textColor = .white
        return label
    }()
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .clear
        return collectionView
    }()
    
    // MARK: - ViewLifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        setupViewModelDelegate()
        viewModel.viewDidLoad()
    }
    
    // MARK: - Private Methods
    private func setup() {
        setupBackground()
        setupSearchController()
        addSubviewsToView()
        setupCollectionView()
    }
    
    private func setupBackground() {
        view.backgroundColor = .customBackgroundColor
    }
    
    private func setupSearchController() {
        self.searchController.searchResultsUpdater = self
        self.searchController.obscuresBackgroundDuringPresentation = false
        self.searchController.hidesNavigationBarDuringPresentation = false
        self.searchController.searchBar.placeholder = "Where to?"
        
        self.navigationItem.searchController = searchController
        self.definesPresentationContext = false
        self.navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    private func addSubviewsToView() {
        setupMainStackView()
        setupCuisineStackView()
    }
    
    private func setupMainStackView() {
        view.addSubview(mainStackView)
        mainStackView.addArrangedSubview(cuisineStackView)
        mainStackView.addArrangedSubview(topRestaurantsLabel)
        
        NSLayoutConstraint.activate([
            mainStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            mainStackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            mainStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            mainStackView.bottomAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func setupCuisineStackView() {
        cuisineStackView.addArrangedSubview(cuisineLabel)
        cuisineStackView.addArrangedSubview(cuisineButtonsStackView)
        
        georgianCuisineButton.configure(with: .customSecondaryColor, icon: UIImage.georgianIcon, name: "Georgian")
        europeanCuisineButton.configure(with: .customSecondaryColor, icon: UIImage.europeanIcon, name: "European")
        asianCuisineButton.configure(with: .customSecondaryColor, icon: UIImage.asianIcon, name: "Asian")
        
        cuisineButtonsStackView.addArrangedSubview(georgianCuisineButton)
        cuisineButtonsStackView.addArrangedSubview(asianCuisineButton)
        cuisineButtonsStackView.addArrangedSubview(europeanCuisineButton)
        
        NSLayoutConstraint.activate([
            georgianCuisineButton.heightAnchor.constraint(equalToConstant: 40),
            asianCuisineButton.heightAnchor.constraint(equalToConstant: 40),
            europeanCuisineButton.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    private func setupCollectionView() {
        view.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: mainStackView.bottomAnchor, constant: 16),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            collectionView.widthAnchor.constraint(equalToConstant: 400),
            collectionView.heightAnchor.constraint(equalToConstant: 200)
        ])
        
        collectionView.register(TopRestaurantCollectionViewCell.self, forCellWithReuseIdentifier: "TopRestaurantsCell")
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.showsHorizontalScrollIndicator = false
    }
    
    private func setupViewModelDelegate() {
        viewModel.delegate = self
    }
}
// MARK: - Search Controller Functions
extension RestaurantsViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        print("")
    }
}

// MARK: - CollectionView DataSource
extension RestaurantsViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        restaurants.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TopRestaurantsCell", for: indexPath) as? TopRestaurantCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        cell.configure(with: restaurants[indexPath.row])
        return cell
    }
}

// MARK: - CollectionView FlowLayoutDelegate
extension RestaurantsViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = Int((collectionView.bounds.width) / 2.5)
        let height = 200
        return CGSize(width: width, height: height)
    }
}

extension RestaurantsViewController: RestaurantsViewModelDelegate {
    func restaurantsFetched(_ restaurants: [Restaurant]) {
        self.restaurants = restaurants
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
    
    func showError(_ error: Error) {
        print("error")
    }
}

#Preview {
    RestaurantsViewController()
}
