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
    
    private let searchController = UISearchController(searchResultsController: nil)
    
    private let georgianCuisineButton = CuisineButton()
    private let europeanCuisineButton = CuisineButton()
    private let asianCuisineButton = CuisineButton()
    
    private let mainStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
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
    
    // MARK: - ViewLifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    // MARK: - Private Methods
    private func setup() {
        setupSearchController()
        setupBackground()
        addSubviewsToView()
    }
    
    private func setupBackground() {
        view.backgroundColor = .customBackgroundColor
    }
    
    private func addSubviewsToView() {
        setupMainStackView()
        setupCuisineStackView()
    }
    
    private func setupMainStackView() {
        view.addSubview(mainStackView)
        
        NSLayoutConstraint.activate([
            mainStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            mainStackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            mainStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            mainStackView.bottomAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func setupCuisineStackView() {
        mainStackView.addArrangedSubview(cuisineStackView)
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
    
    private func setupSearchController() {
        self.searchController.searchResultsUpdater = self
        self.searchController.obscuresBackgroundDuringPresentation = false
        self.searchController.hidesNavigationBarDuringPresentation = false
        self.searchController.searchBar.placeholder = "Where to?"
        
        self.navigationItem.searchController = searchController
        self.definesPresentationContext = false
        self.navigationItem.hidesSearchBarWhenScrolling = false
    }
}
// MARK: - Search Controller Functions
extension RestaurantsViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        print("")
    }
}

#Preview {
    RestaurantsViewController()
}
