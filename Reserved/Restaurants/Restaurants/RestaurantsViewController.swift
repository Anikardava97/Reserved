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
    private var restaurants = [Restaurant]()
    private var filteredCuisineRestaurants = [Restaurant]()
    private var filteredTopRestaurants = [Restaurant]()
    private var selectedCuisineType: String?
    
    private let searchController = UISearchController(searchResultsController: nil)
    
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
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .clear
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
        segmentedControl.addTarget(self, action: #selector(segmentedControlValueChanged(_:)), for: .valueChanged)
        selectedCuisineType = nil
        
        segmentedControl.tintColor = .customSecondaryColor
        segmentedControl.selectedSegmentTintColor = .customAccentColor
        
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
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    // MARK: - ViewLifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        viewModel.viewDidLoad()
    }
    
    // MARK: - Private Methods
    private func setup() {
        setupViewModelDelegate()
        setupBackground()
        setupCollectionView()
        setupTableView()
        setupSearchController()
        setupScrollView()
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
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            scrollStackViewContainer.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            scrollStackViewContainer.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            scrollStackViewContainer.topAnchor.constraint(equalTo: scrollView.topAnchor),
            scrollStackViewContainer.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            scrollStackViewContainer.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            collectionView.heightAnchor.constraint(equalToConstant: 200),
            contentSegmentedControl.heightAnchor.constraint(equalToConstant: 44)
        ])
    }
    
    private func setupScrollView() {
        scrollView.showsVerticalScrollIndicator = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    @objc private func segmentedControlValueChanged(_ sender: UISegmentedControl) {
        let selectedTitle = sender.titleForSegment(at: sender.selectedSegmentIndex) ?? "All"
        selectedCuisineType = selectedTitle
        filteredCuisineRestaurants = filterRestaurantsByCuisine(selectedTitle)
        tableView.reloadData()
    }
    
    private func filterRestaurantsByCuisine(_ cuisine: String) -> [Restaurant] {
        switch cuisine {
        case "Georgian":
            return restaurants.filter { $0.cuisine == "Georgian" }
        case "Asian":
            return restaurants.filter { $0.cuisine == "Asian" }
        case "European":
            return restaurants.filter { $0.cuisine == "European" }
        default:
            return restaurants
        }
    }
    
    private func setupCollectionView() {
        collectionView.register(TopRestaurantCollectionViewCell.self, forCellWithReuseIdentifier: "topRestaurantsCell")
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.showsHorizontalScrollIndicator = false
    }
    
    private func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(AllRestaurantsTableViewCell.self, forCellReuseIdentifier: "allRestaurantsCell")
        
        tableView.backgroundColor = .customBackgroundColor
        tableView.isScrollEnabled = false
    }
}

// MARK: - Search Controller Functions
extension RestaurantsViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text else {
            return
        }
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

// MARK: - UISearchBarDelegate
extension RestaurantsViewController: UISearchBarDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        topRestaurantsLabel.isHidden = true
        allRestaurantsLabel.isHidden = true
        collectionView.isHidden = true
        contentSegmentedControl.isHidden = true
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        topRestaurantsLabel.isHidden = false
        allRestaurantsLabel.isHidden = false
        collectionView.isHidden = false
        contentSegmentedControl.isHidden = false
    }
}

// MARK: - CollectionView DataSource
extension RestaurantsViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        filteredTopRestaurants.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "topRestaurantsCell", for: indexPath) as? TopRestaurantCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        if indexPath.row < filteredTopRestaurants.count {
            cell.configure(with: filteredTopRestaurants[indexPath.row])
        }
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

// MARK: - UICollectionViewDelegate
extension RestaurantsViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row < filteredTopRestaurants.count {
            let selectedRestaurant = filteredTopRestaurants[indexPath.row]
            viewModel.navigateToRestaurantDetails(with: selectedRestaurant)
        }
    }
}

// MARK: - TableViewDataSource
extension RestaurantsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        filteredCuisineRestaurants.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "allRestaurantsCell", for: indexPath) as? AllRestaurantsTableViewCell else {
            return UITableViewCell()
        }
        cell.configure(with: filteredCuisineRestaurants[indexPath.row])
        return cell
    }
}

// MARK: - TableViewDelegate
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

// MARK: - RestaurantsViewModelDelegate
extension RestaurantsViewController: RestaurantsViewModelDelegate {
    func restaurantsFetched(_ restaurants: [Restaurant]) {
        let filteredTopRestaurants = restaurants.filter { $0.reviewStars >= 4.5 }
        self.restaurants = restaurants
        self.filteredTopRestaurants = filteredTopRestaurants
        self.filteredCuisineRestaurants = restaurants
        
        DispatchQueue.main.async {
            self.collectionView.reloadData()
            self.tableView.reloadData()
        }
    }
    
    func showError(_ error: Error) {
        print("error")
    }
    
    func navigateToRestaurantDetails(with restaurant: Restaurant) {
        let restaurantDetailsViewController = RestaurantDetailsViewController()
        restaurantDetailsViewController.configure(with: restaurant)
        navigationController?.pushViewController(restaurantDetailsViewController, animated: true)
    }
}

#Preview {
    RestaurantsViewController()
}
