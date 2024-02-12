//
//  MyOrdersViewController.swift
//  Reserved
//
//  Created by Ani's Mac on 10.02.24.
//

import UIKit

final class MyOrdersViewController: UIViewController {
    // MARK: - Properties
    let emptyStateViewController = EmptyStateViewController(
        title: "Start ordering food",
        description: "You don't have any orders yet. Start your journey by exploring your favorite restaurants.",
        animationName: "Animation - 1706506120281"
    )
    
    private let myOrdersLabel: UILabel = {
        let label = UILabel()
        label.text = "My Orders"
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.backgroundColor = .clear
        tableView.showsVerticalScrollIndicator = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    // MARK: - ViewLifeCycles
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        setupTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        ReservationManager.shared.loadReservationsForCurrentUser()
        
        if ReservationManager.shared.myReservations.isEmpty {
            showEmptyState()
        } else {
            hideEmptyState()
        }
        tableView.reloadData()
    }
    
    // MARK: - Methods
    private func setup() {
        setupBackground()
        setupSubviews()
        setupConstraints()
        setupTableView()
    }
    
    private func setupBackground() {
        view.backgroundColor = .customBackgroundColor
    }
    
    private func setupSubviews() {
        view.addSubview(myOrdersLabel)
        view.addSubview(tableView)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            myOrdersLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            myOrdersLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            myOrdersLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: 16),
            
            tableView.topAnchor.constraint(equalTo: myOrdersLabel.bottomAnchor, constant: 16),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
    
    private func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(CheckoutTableViewCell.self, forCellReuseIdentifier: "CheckoutTableViewCell")
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
}

// MARK: - Extension: UITableViewDataSource
extension MyOrdersViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return ReservationManager.shared.myReservations.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let order =  ReservationManager.shared.myReservations[section]
        return order.foodItems?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CheckoutTableViewCell", for: indexPath) as? CheckoutTableViewCell else {
            return UITableViewCell()
        }
        let order = ReservationManager.shared.myReservations[indexPath.section]
        let foodItem = order.foodItems?[indexPath.row]
        cell.configure(with: foodItem!)
        return cell
    }
}

// MARK:  Extension: TableViewDelegate
extension MyOrdersViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = .clear
        
        let titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.textColor = .white
        titleLabel.font = UIFont.boldSystemFont(ofSize: 16)
        
        let giftLabel = UILabel()
        giftLabel.translatesAutoresizingMaskIntoConstraints = false
        giftLabel.textColor = .white.withAlphaComponent(0.8)
        giftLabel.font = UIFont.systemFont(ofSize: 14)
        
        let order = ReservationManager.shared.myReservations[section]
        titleLabel.text = "\(order.restaurantName) - \(order.reservationDate) at \(order.reservationTime)"
        giftLabel.text = order.gift != nil ? "Gift: \(order.gift!.name)" : "Gift: None"
        
        headerView.addSubview(titleLabel)
        headerView.addSubview(giftLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: headerView.topAnchor, constant: 8),
            titleLabel.leadingAnchor.constraint(equalTo: headerView.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: headerView.trailingAnchor),
            
            giftLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            giftLabel.leadingAnchor.constraint(equalTo: headerView.leadingAnchor),
            giftLabel.trailingAnchor.constraint(equalTo: headerView.trailingAnchor),
            giftLabel.bottomAnchor.constraint(equalTo: headerView.bottomAnchor, constant: -8)
        ])
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60
    }
}




