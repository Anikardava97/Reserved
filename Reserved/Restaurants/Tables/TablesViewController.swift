//
//  TablesViewController.swift
//  Reserved
//
//  Created by Ani's Mac on 22.01.24.
//

import UIKit

class TablesViewController: UIViewController {
    // MARK: - Properties
    private let tableImages = ["Table12", "Table2", "Table8", "Table9",
                               "Table6", "Table4", "Table10", "Table3",
                               "Table2", "Table5", "Table7", "Table1",
                               
                               "Table11", "Table5", "Table2", "Table3",
                               "Table8", "Table4","Table12", "Table9",
                               "Table6", "Table10", "Table1", "Table7"]
    
    var selectedDate: String?
    var selectedTime: String?
    var selectedGuests: Int?
    
    private lazy var chooseTableStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 32
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
    
    private let reservationButton = MainButtonComponent(
        text: "Reserve",
        textColor: .white,
        backgroundColor: .customAccentColor
    )
    
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
        chooseTableStackView.addArrangedSubview(reservationButton)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            chooseTableStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            chooseTableStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            chooseTableStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -32),
            collectionView.heightAnchor.constraint(equalToConstant: 540),
        ])
    }
    
    private func setupCollectionView() {
        collectionView.register(TablesCollectionViewCell.self, forCellWithReuseIdentifier: "table")
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.isPagingEnabled = true
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
        return cell
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
