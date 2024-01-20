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
    private let georgianCuisineButton = CuisineButtonComponent()
    private let europeanCuisineButton = CuisineButtonComponent()
    private let asianCuisineButton = CuisineButtonComponent()
    
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
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
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
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
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
    
    private let allRestaurantsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        return stackView
    }()
    
    private let allRestaurantsLabel: UILabel = {
        let label = UILabel()
        label.text = "All Restaurants"
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        label.textColor = .white
        return label
    }()
    
    private  var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    // MARK: - ViewLifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        setupViewModelDelegate()
        viewModel.viewDidLoad()
        self.tableView.backgroundColor = .customBackgroundColor
    }
    
    // MARK: - Private Methods
    private func setup() {
        setupBackground()
        setupSearchController()
        setupSubviews()
        setupConstraints()
        setupCuisineStackView()
        setupCollectionView()
        setupTableView()
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
    
    private func setupSubviews() {
        view.addSubview(mainStackView)
        
        mainStackView.addArrangedSubview(cuisineStackView)
        
        cuisineStackView.addArrangedSubview(cuisineLabel)
        cuisineStackView.addArrangedSubview(cuisineButtonsStackView)
        
        cuisineButtonsStackView.addArrangedSubview(georgianCuisineButton)
        cuisineButtonsStackView.addArrangedSubview(asianCuisineButton)
        cuisineButtonsStackView.addArrangedSubview(europeanCuisineButton)
        
        mainStackView.addArrangedSubview(topRestaurantsLabel)
        view.addSubview(collectionView)
        view.addSubview(tableView)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            mainStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            mainStackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            mainStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            mainStackView.bottomAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            georgianCuisineButton.heightAnchor.constraint(equalToConstant: 40),
            asianCuisineButton.heightAnchor.constraint(equalToConstant: 40),
            europeanCuisineButton.heightAnchor.constraint(equalToConstant: 40),
            
            collectionView.topAnchor.constraint(equalTo: mainStackView.bottomAnchor, constant: 16),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            collectionView.widthAnchor.constraint(equalTo: view.widthAnchor),
            collectionView.heightAnchor.constraint(equalToConstant: 200),
            
            tableView.topAnchor.constraint(equalTo: collectionView.bottomAnchor, constant: 20),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20)
        ])
    }
    
    private func setupCuisineStackView() {
        georgianCuisineButton.configure(with: .customSecondaryColor, icon: UIImage.georgianIcon, name: "Georgian")
        europeanCuisineButton.configure(with: .customSecondaryColor, icon: UIImage.europeanIcon, name: "European")
        asianCuisineButton.configure(with: .customSecondaryColor, icon: UIImage.asianIcon, name: "Asian")
    }
    
    private func setupCollectionView() {
        collectionView.register(TopRestaurantCollectionViewCell.self, forCellWithReuseIdentifier: "topRestaurantsCell")
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.showsHorizontalScrollIndicator = false
    }
    
    private func setupViewModelDelegate() {
        viewModel.delegate = self
    }
    
    private func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(AllRestaurantsTableViewCell.self, forCellReuseIdentifier: "allRestaurantsCell")
        tableView.showsVerticalScrollIndicator = false
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
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "topRestaurantsCell", for: indexPath) as? TopRestaurantCollectionViewCell else {
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

// MARK: - RestaurantsViewModelDelegate
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

// MARK: - TableViewDataSource
extension RestaurantsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        restaurants.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "allRestaurantsCell", for: indexPath) as? AllRestaurantsTableViewCell else {
            return UITableViewCell()
        }
        cell.configure(with: restaurants[indexPath.row])
        return cell
    }
}

// MARK: - TableViewDelegate
extension RestaurantsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
}

#Preview {
    RestaurantsViewController()
}

