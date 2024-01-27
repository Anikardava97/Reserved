//
//  TablesViewController.swift
//  Reserved
//
//  Created by Ani's Mac on 22.01.24.
//

import UIKit

struct Table {
    let imageName: String
    let capacity: Int
}

class TablesViewController: UIViewController {
    // MARK: - Properties
    private let tableImages = ["Table12", "Table2", "Table8", "Table9",
                               "Table6", "Table4", "Table10", "Table3",
                               "Table2", "Table5", "Table7", "Table1",
                               
                               "Table11", "Table5", "Table2", "Table3",
                               "Table8", "Table4","Table12", "Table9",
                               "Table6", "Table10", "Table1", "Table7"]
    var selectedRestaurant: Restaurant?
    var selectedDate: String?
    var selectedTime: String?
    var selectedGuests: Int?
    
    private let tables = [
        Table(imageName: "Table12", capacity: 12),
        Table(imageName: "Table2", capacity: 2),
        Table(imageName: "Table8", capacity: 8),
        Table(imageName: "Table9", capacity: 9),
        Table(imageName: "Table6", capacity: 6),
        Table(imageName: "Table4", capacity: 4),
        Table(imageName: "Table10", capacity: 10),
        Table(imageName: "Table3", capacity: 3),
        Table(imageName: "Table2", capacity: 2),
        Table(imageName: "Table5", capacity: 5),
        Table(imageName: "Table7", capacity: 7),
        Table(imageName: "Table1", capacity: 1),
        Table(imageName: "Table11", capacity: 11),
        Table(imageName: "Table5", capacity: 5),
        Table(imageName: "Table2", capacity: 2),
        Table(imageName: "Table3", capacity: 3),
        Table(imageName: "Table8", capacity: 8),
        Table(imageName: "Table4", capacity: 4),
        Table(imageName: "Table12", capacity: 12),
        Table(imageName: "Table9", capacity: 9),
        Table(imageName: "Table6", capacity: 6),
        Table(imageName: "Table10", capacity: 10),
        Table(imageName: "Table1", capacity: 1),
        Table(imageName: "Table7", capacity: 7),
    ]
    
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
        collectionView.register(TablesCollectionViewCell.self, forCellWithReuseIdentifier: "table")
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.isPagingEnabled = true
    }
    
    private func isTableAvailable(forGuests guests: Int, tableIndex: Int) -> Bool {
        let tableCapacity = tables[tableIndex].capacity
        
        return tableCapacity == guests
    }
    
    private func handleReservation() {
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
        tableImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "table", for: indexPath) as? TablesCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        cell.tableImageView.image = UIImage(named: tableImages[indexPath.row])
        
        if let guests = selectedGuests {
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
        let guests = selectedGuests ?? 0
        let isAvailable = isTableAvailable(forGuests: guests, tableIndex: indexPath.row)
        
        if isAvailable {
            let confirmationAlert = UIAlertController(
                title: "Confirm Reservation",
                message: "Are you sure you want to reserve a table at \(selectedRestaurant?.name ?? "this restaurant") for \(guests) guests on \(selectedDate ?? "") at \(selectedTime ?? "")?",
                preferredStyle: .alert
            )
            
            let confirmAction = UIAlertAction(
                title: "Confirm", style: .default) { [weak self] _ in
                self?.handleReservation()
            }
            
            let cancelAction = UIAlertAction(
                title: "Cancel",
                style: .cancel,
                handler: nil)
            
            confirmationAlert.addAction(confirmAction)
            confirmationAlert.addAction(cancelAction)
            
            present(confirmationAlert, animated: true, completion: nil)
        } else {
            let unavailableTableAlert = UIAlertController(
                title: "Table Unavailable 😳",
                message: "This table is not available for \(guests) guests. Please choose a different table.",
                preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            unavailableTableAlert.addAction(okAction)
            present(unavailableTableAlert, animated: true, completion: nil)
        }
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

#Preview {
    TablesViewController()
}
