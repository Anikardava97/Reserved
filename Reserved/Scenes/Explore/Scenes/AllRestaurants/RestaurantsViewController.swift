//
//  RestaurantsViewController.swift
//  Reserved
//
//  Created by Ani's Mac on 18.01.24.
//

import UIKit

final class RestaurantsViewController: UIViewController {
    // MARK: - Properties
    private let viewModel = RestaurantsViewModel()
    private let searchController = UISearchController(searchResultsController: nil)
    private var restaurants = [Restaurant]()
    private var filteredCuisineRestaurants = [Restaurant]()
    private var filteredTopRestaurants = [Restaurant]()
    private var selectedCuisineType: String?
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private let scrollStackViewContainer: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.spacing = 18
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
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
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()
    
    private let allRestaurantsLabel: UILabel = {
        let label = UILabel()
        label.text = "All Restaurants"
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        label.textColor = .white
        return label
    }()
    
    private lazy var contentSegmentedControl: UISegmentedControl = {
        let segmentedControl = UISegmentedControl(items: ["All", "Georgian", "Asian", "European"])
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.tintColor = .customSecondaryColor
        segmentedControl.selectedSegmentTintColor = .customAccentColor
        segmentedControl.addTarget(self, action: #selector(segmentedControlValueChanged(_:)), for: .valueChanged)
        
        let normalTextAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.white.withAlphaComponent(0.8),
            .font: UIFont.systemFont(ofSize: 14)
        ]
        let selectedTextAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.white,
            .font: UIFont.boldSystemFont(ofSize: 14)
        ]
        
        segmentedControl.setTitleTextAttributes(normalTextAttributes, for: .normal)
        segmentedControl.setTitleTextAttributes(selectedTextAttributes, for: .selected)
        return segmentedControl
    }()
    
    private  var tableView: UITableView = {
        let tableView = SelfSizedTableView()
        tableView.backgroundColor = .clear
        tableView.isScrollEnabled = false
        return tableView
    }()
    
    // MARK: - ViewLifeCycles
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        viewModel.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
        collectionView.reloadData()
    }
    
    // MARK: - Private Methods
    private func setup() {
        setupViewModelDelegate()
        setupBackground()
        setupSearchController()
        setupScrollView()
        setupCollectionView()
        setupTableView()
        setupSubviews()
        setupConstraints()
    }
    
    private func setupViewModelDelegate() {
        viewModel.delegate = self
    }
    
    private func setupBackground() {
        view.backgroundColor = .customBackgroundColor
    }
    
    private func setupSearchController() {
        self.searchController.searchResultsUpdater = self
        self.searchController.obscuresBackgroundDuringPresentation = false
        self.searchController.hidesNavigationBarDuringPresentation = false
        if let searchTextField = self.searchController.searchBar.value(forKey: "searchField") as? UITextField {
            searchTextField.attributedPlaceholder = NSAttributedString(
                string: "Where to?",
                attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
        }
        self.searchController.searchBar.delegate = self
        self.navigationItem.searchController = searchController
        self.definesPresentationContext = false
        self.navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    private func setupScrollView() {
        scrollView.showsVerticalScrollIndicator = false
    }
    
    private func setupCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(TopRestaurantCollectionViewCell.self, forCellWithReuseIdentifier: "topRestaurantsCell")
    }
    
    private func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(AllRestaurantsTableViewCell.self, forCellReuseIdentifier: "allRestaurantsCell")
    }
    
    private func setupSubviews() {
        view.addSubview(scrollView)
        scrollView.addSubview(scrollStackViewContainer)
        scrollStackViewContainer.addArrangedSubview(topRestaurantsLabel)
        scrollStackViewContainer.addArrangedSubview(collectionView)
        scrollStackViewContainer.addArrangedSubview(allRestaurantsLabel)
        scrollStackViewContainer.addArrangedSubview(contentSegmentedControl)
        scrollStackViewContainer.addArrangedSubview(tableView)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            scrollStackViewContainer.topAnchor.constraint(equalTo: scrollView.topAnchor),
            scrollStackViewContainer.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            scrollStackViewContainer.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            scrollStackViewContainer.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            scrollStackViewContainer.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            collectionView.heightAnchor.constraint(equalToConstant: 200),
            contentSegmentedControl.heightAnchor.constraint(equalToConstant: 44)
        ])
    }
    
    // MARK: - Actions
    @objc private func segmentedControlValueChanged(_ sender: UISegmentedControl) {
        let selectedTitle = sender.titleForSegment(at: sender.selectedSegmentIndex) ?? "All"
        selectedCuisineType = selectedTitle
        filteredCuisineRestaurants = viewModel.filterRestaurantsByCuisine(selectedTitle)
        tableView.reloadData()
    }
}

// MARK: - Extension: Search Controller Functions
extension RestaurantsViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text else { return }
        if !searchText.isEmpty {
            filteredCuisineRestaurants = restaurants.filter { $0.name.lowercased().contains(searchText.lowercased()) }
        } else {
            filteredCuisineRestaurants = restaurants
        }
        self.tableView.reloadData()
        
        if let searchTextField = searchController.searchBar.value(forKey: "searchField") as? UITextField {
            searchTextField.textColor = .white
        }
    }
}

// MARK:  Extension: UISearchBarDelegate
extension RestaurantsViewController: UISearchBarDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        topRestaurantsLabel.isHidden = true
        allRestaurantsLabel.isHidden = true
        collectionView.isHidden = true
        contentSegmentedControl.isHidden = true
    }
}

// MARK: - Extension: UICollectionViewDataSource
extension RestaurantsViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int { filteredTopRestaurants.count }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "topRestaurantsCell", for: indexPath) as? TopRestaurantCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        let restaurant = filteredTopRestaurants[indexPath.row]
        cell.configure(
            with: restaurant,
            isFavorite: FavoritesManager.shared.isFavorite(restaurant: restaurant)
        )
        cell.favoriteButtonDidTap = { [weak self] in
            self?.viewModel.toggleFavorite(for: restaurant)
        }
        return cell
    }
}

// MARK:  Extension: UICollectionViewDelegate
extension RestaurantsViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row < filteredTopRestaurants.count {
            let selectedRestaurant = filteredTopRestaurants[indexPath.row]
            viewModel.navigateToRestaurantDetails(with: selectedRestaurant)
        }
    }
}

// MARK:  Extension: UICollectionViewDelegateFlowLayout
extension RestaurantsViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = Int((collectionView.bounds.width) / 2.5)
        let height = 200
        return CGSize(width: width, height: height)
    }
}

// MARK: - Extension: TableViewDataSource
extension RestaurantsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        filteredCuisineRestaurants.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "allRestaurantsCell", for: indexPath) as? AllRestaurantsTableViewCell else {
            return UITableViewCell()
        }
        
        let restaurant = filteredCuisineRestaurants[indexPath.row]
        if indexPath.row < filteredCuisineRestaurants.count {
            cell.configure(
                with: restaurant,
                isFavorite: FavoritesManager.shared.isFavorite(restaurant: restaurant)
            )
            cell.favoriteButtonDidTap = { [weak self] in
                self?.viewModel.toggleFavorite(for: restaurant)
            }
        }
        return cell
    }
}

// MARK:  Extension: TableViewDelegate
extension RestaurantsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row < filteredCuisineRestaurants.count {
            let selectedRestaurant = filteredCuisineRestaurants[indexPath.row]
            viewModel.navigateToRestaurantDetails(with: selectedRestaurant)
        }
    }
}

// MARK: - Extension: RestaurantsViewModelDelegate
extension RestaurantsViewController: RestaurantsViewModelDelegate {
    func restaurantsFetched(_ restaurants: [Restaurant]) {
        self.restaurants = restaurants
        
        let filteredTopRestaurants = restaurants.filter { $0.reviewStars >= 4.5 }
        self.filteredTopRestaurants = filteredTopRestaurants
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
        
        if selectedCuisineType == nil || selectedCuisineType == "All" {
            self.filteredCuisineRestaurants = restaurants
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    func showError(_ error: Error) {
        print(error)
    }
    
    func navigateToRestaurantDetails(with restaurant: Restaurant) {
        let restaurantDetailsViewController = RestaurantDetailsViewController()
        restaurantDetailsViewController.configure(with: restaurant)
        navigationController?.pushViewController(restaurantDetailsViewController, animated: true)
    }
    
    func favoriteStatusChanged(for restaurant: Restaurant) {
        if let collectionIndex = filteredTopRestaurants.firstIndex(where: { $0.id == restaurant.id }) {
            filteredTopRestaurants[collectionIndex] = restaurant
            let indexPath = IndexPath(item: collectionIndex, section: 0)
            collectionView.reloadItems(at: [indexPath])
        }
        
        if let tableIndex = filteredCuisineRestaurants.firstIndex(where: { $0.id == restaurant.id }) {
            filteredCuisineRestaurants[tableIndex] = restaurant
            let indexPath = IndexPath(row: tableIndex, section: 0)
            tableView.reloadRows(at: [indexPath], with: .automatic)
        }
    }
}

