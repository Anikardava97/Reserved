//
//  FavoritesViewController.swift
//  Reserved
//
//  Created by Ani's Mac on 18.01.24.
//

import UIKit

final class FavoritesViewController: UIViewController {
    
    // MARK: - Properties
    private var viewModel = FavoritesViewModel()
    
    let emptyStateViewController = EmptyStateViewController(
        title: "Start your list",
        description: "When you find a property you like, tap the heart icon to save it here",
        animationName: "Animation - 1706506113575")
    
    private var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    // MARK: - ViewLifeCycles
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        
        viewModel.onFavoritesUpdated = { [weak self] in
            guard let self = self else { return }
            self.tableView.reloadData()
            if self.viewModel.numberOfFavorites == 0 {
                self.showEmptyState()
            } else {
                self.hideEmptyState()
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.loadFavorites()
    }
    
    // MARK: - Private Methods
    func updateFavoritesBadgeCount() {
        let count = FavoritesManager.shared.favoriteRestaurants.count
        self.tabBarController?.tabBar.items?[3].badgeValue = count > 0 ? "\(count)" : nil
    }
    
    private func showEmptyState() {
        if children.contains(emptyStateViewController) { return }
        addChild(emptyStateViewController)
        view.addSubview(emptyStateViewController.view)
        emptyStateViewController.view.frame = view.bounds
        emptyStateViewController.didMove(toParent: self)
    }
    
    private func hideEmptyState() {
        if children.contains(emptyStateViewController) {
            emptyStateViewController.willMove(toParent: nil)
            emptyStateViewController.view.removeFromSuperview()
            emptyStateViewController.removeFromParent()
        }
    }
    
    private func setup() {
        setupBackground()
        setupTableView()
        setupSubviews()
        setupConstraints()
    }
    
    private func setupBackground() {
        view.backgroundColor = .customBackgroundColor
    }
    
    private func setupSubviews() {
        view.addSubview(tableView)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -24)
        ])
    }
    
    private func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(FavoriteRestaurantsTableViewCell.self, forCellReuseIdentifier: "favoriteRestaurantsCell")
        
        tableView.backgroundColor = .customBackgroundColor
        tableView.showsVerticalScrollIndicator = false
    }
}

// MARK: - TableViewDataSource
extension FavoritesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        FavoritesManager.shared.getAllFavorites().count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "favoriteRestaurantsCell", for: indexPath) as? FavoriteRestaurantsTableViewCell else {
            return UITableViewCell()
        }
        let restaurant = viewModel.favoriteAt(index: indexPath.row)
        cell.configure(with: restaurant)
        cell.onFavoriteDidTap = { [weak self] in
            self?.viewModel.toggleFavorite(restaurant: restaurant)
        }
        return cell
    }
}

// MARK: - Extension: TableViewDelegate
extension FavoritesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}

// MARK: - Extension: FavoritesManagerDelegate
extension FavoritesViewController: FavoritesManagerDelegate {
    func favoritesManagerDidUpdateFavorites() {
        updateFavoritesBadgeCount()
    }
}
