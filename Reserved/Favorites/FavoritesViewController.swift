//
//  FavoritesViewController.swift
//  Reserved
//
//  Created by Ani's Mac on 18.01.24.
//

import UIKit

struct FavoriteRestaurant: Codable {
    let id: Int
}

struct MockRestaurant {
    var name: String
    var cuisine: String
    var image: UIImage
}

final class FavoritesViewController: UIViewController {
    // MARK: - Properties
    var favoriteRestaurants: [Restaurant] = []

    private var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    private var mockRestaurants = [
        MockRestaurant(name: "Stamba", cuisine: "Georgian", image: UIImage(named: "Ono1")!),
        MockRestaurant(name: "Stamba", cuisine: "Georgian", image: UIImage(named: "Ono1")!),
        MockRestaurant(name: "Stamba", cuisine: "Georgian", image: UIImage(named: "Ono1")!),
    ]
    
    // MARK: - ViewLifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    // MARK: - Private Methods
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
        tableView.isScrollEnabled = false
    }
}

// MARK: - TableViewDataSource
extension FavoritesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        mockRestaurants.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "favoriteRestaurantsCell", for: indexPath) as? FavoriteRestaurantsTableViewCell else {
            return UITableViewCell()
        }
        let restaurant = mockRestaurants[indexPath.row]
        cell.configure(with: restaurant)

        return cell
    }
}

// MARK: - TableViewDelegate
extension FavoritesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
        }
    }

#Preview {
    FavoritesViewController()
}









