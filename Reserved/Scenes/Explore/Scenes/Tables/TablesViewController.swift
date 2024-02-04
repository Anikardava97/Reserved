//
//  TablesViewController.swift
//  Reserved
//
//  Created by Ani's Mac on 22.01.24.
//

import UIKit

final class TablesViewController: UIViewController {
    // MARK: - Properties
    private var viewModel: TablesViewModel?
    
    private lazy var chooseTableStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 24
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let chooseTableTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Pick the table that suits you best!"
        label.font = UIFont.systemFont(ofSize: 24, weight: .medium)
        label.numberOfLines = 2
        label.textColor = .white
        return label
    }()
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .customBackgroundColor
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.isPagingEnabled = true
        return collectionView
    }()
    
    // MARK: - ViewLifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    // MARK: - Private Methods
    private func setup() {
        setupBackground()
        setupSubviews()
        setupConstraints()
        setupCollectionView()
    }
    
    func setup(with viewModel: TablesViewModel) {
        self.viewModel = viewModel
    }
    
    private func setupBackground() {
        view.backgroundColor = .customBackgroundColor
    }
    
    private func setupSubviews() {
        view.addSubview(chooseTableStackView)
        chooseTableStackView.addArrangedSubview(chooseTableTitleLabel)
        chooseTableStackView.addArrangedSubview(collectionView)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            chooseTableStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            chooseTableStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            chooseTableStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            collectionView.leadingAnchor.constraint(equalTo: chooseTableStackView.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: chooseTableStackView.trailingAnchor),
            collectionView.heightAnchor.constraint(equalTo: view.heightAnchor)
        ])
    }
    
    private func setupCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(TablesCollectionViewCell.self, forCellWithReuseIdentifier: "table")
    }
    
    private func isTableAvailable(forGuests guests: Int, tableIndex: Int) -> Bool {
        return viewModel?.isTableAvailable(forGuests: guests, tableIndex: tableIndex) ?? false
    }
    
    private func performReservation() {
        guard let viewModel = viewModel,
              let selectedDate = viewModel.selectedDate,
              let selectedTime = viewModel.selectedTime,
              let selectedGuests = viewModel.selectedGuests,
              let selectedRestaurant = viewModel.selectedRestaurant else { return }
        
        let confirmationViewController = ConfirmationViewController()
        confirmationViewController.selectedRestaurant = selectedRestaurant
        confirmationViewController.selectedDate = selectedDate
        confirmationViewController.selectedTime = selectedTime
        confirmationViewController.selectedGuests = selectedGuests
        
        navigationController?.pushViewController(confirmationViewController, animated: true)
    }
}

// MARK: - CollectionView DataSource
extension TablesViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel?.tableImages.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "table", for: indexPath) as? TablesCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        if let imageName = viewModel?.tableImages[indexPath.row] {
            cell.tableImageView.image = UIImage(named: imageName)
        }
        
        if let guests = viewModel?.selectedGuests {
            let isAvailable = isTableAvailable(forGuests: guests, tableIndex: indexPath.row)
            cell.tableImageView.alpha = isAvailable ? 1.0 : 0.4
            cell.animateAvailability(isAvailable: isAvailable)
        }
        return cell
    }
}

// MARK: - UICollectionViewDelegate
extension TablesViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        handleTableSelection(at: indexPath)
    }
    
    // MARK: - Helper Methods
    private func handleTableSelection(at indexPath: IndexPath) {
        guard let guests = viewModel?.selectedGuests else { return }
        
        let isAvailable = isTableAvailable(forGuests: guests, tableIndex: indexPath.row)
        
        if isAvailable {
            showConfirmationAlert(for: guests, at: indexPath)
        } else {
            AlertManager.shared.showUnavailableTableAlert(from: self, for: guests)
        }
    }
    
    private func showConfirmationAlert(for guests: Int, at indexPath: IndexPath) {
        let confirmationAlert = UIAlertController(
            title: "Confirm Reservation",
            message: makeConfirmationMessage(for: guests, at: indexPath),
            preferredStyle: .alert
        )
        
        let confirmAction = UIAlertAction(
            title: "Confirm", style: .default) { [weak self] _ in
                self?.performReservation()
            }
        
        let cancelAction = UIAlertAction(
            title: "Cancel",
            style: .cancel,
            handler: nil)
        
        confirmationAlert.addAction(confirmAction)
        confirmationAlert.addAction(cancelAction)
        
        present(confirmationAlert, animated: true, completion: nil)
    }
    
    private func makeConfirmationMessage(for guests: Int, at indexPath: IndexPath) -> String {
        return "Are you sure you want to reserve a table at \(viewModel?.selectedRestaurant?.name ?? "this restaurant") for \(guests) guests on \(viewModel?.selectedDate ?? "") at \(viewModel?.selectedTime ?? "")?"
    }
}

// MARK: - CollectionView FlowLayoutDelegate
extension TablesViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let frameWidth = Int(collectionView.frame.width)
        let itemWidth = frameWidth / 5
        let itemHeight = 80
        return CGSize(width: itemWidth, height: itemHeight)
    }
}

