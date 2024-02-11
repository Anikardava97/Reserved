//
//  MyCreditCardsViewController.swift
//  Reserved
//
//  Created by Ani's Mac on 10.02.24.
//

import UIKit

final class MyCreditCardsViewController: UIViewController {
    // MARK: - Properties
    var creditCardManager: CreditCardManager?
    
    private let mainStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 24
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.layoutMargins = UIEdgeInsets(top: 24, left: 16, bottom: 24, right: 16)
        return stackView
    }()

    private let myCreditCardsLabel: UILabel = {
        let label = UILabel()
        label.text = "My Credit Cards"
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        label.textColor = .white
        return label
    }()
    
    private var tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .clear
        tableView.showsVerticalScrollIndicator = false
        return tableView
    }()
    
    private lazy var addButton: CircularButton = {
        let button = CircularButton()
        button.setTitle("+", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 24)
        button.titleLabel?.textAlignment = .center
        button.backgroundColor = .customAccentColor
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(addCardButtonDidTap), for: .touchUpInside)
        return button
    }()
    
    // MARK: - ViewLifeCycles
    override func viewDidLoad() {
        super.viewDidLoad()
        creditCardManager = CreditCardManager.shared
        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        creditCardManager?.loadCardsForCurrentUser()
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
        view.addSubview(mainStackView)
        mainStackView.addArrangedSubview(myCreditCardsLabel)
        mainStackView.addArrangedSubview(tableView)
        view.addSubview(addButton)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            mainStackView.topAnchor.constraint(equalTo: view.topAnchor, constant: 16),
            mainStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mainStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            mainStackView.bottomAnchor.constraint(equalTo: addButton.topAnchor, constant: -24),
            
            addButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32),
            addButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -32),
            addButton.widthAnchor.constraint(equalToConstant: 44),
            addButton.heightAnchor.constraint(equalToConstant: 44)
        ])
    }
    
    private func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(MyCreditCardsTableViewCell.self, forCellReuseIdentifier: "myCreditCardsTableViewCell")
    }
    
    // MARK: - Actions
    @objc private func addCardButtonDidTap() {
        let addCardViewController = AddCardViewController()
        addCardViewController.creditCardManager = self.creditCardManager
        addCardViewController.delegate = self
        navigationController?.pushViewController(addCardViewController, animated: true)
    }
}

// MARK:  Extension: UITableViewDataSource
extension MyCreditCardsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return creditCardManager?.cards.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "myCreditCardsTableViewCell", for: indexPath) as? MyCreditCardsTableViewCell,
              let card = creditCardManager?.cards[indexPath.row] else {
            return UITableViewCell()
        }
        cell.configure(with: card)
        cell.delegate = self
        return cell
    }
}

// MARK:  Extension: TableViewDelegate
extension MyCreditCardsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
}

// MARK:  Extension: MyCreditCardsTableViewCellDelegate
extension MyCreditCardsViewController: MyCreditCardsTableViewCellDelegate {
    func removeCard(for cell: MyCreditCardsTableViewCell?) {
        guard
            let cell = cell,
            let indexPath = tableView.indexPath(for: cell) else { return }
        creditCardManager?.removeCard(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .automatic)
    }
}

// MARK:  Extension: AddCardViewControllerDelegate
extension MyCreditCardsViewController: AddCardViewControllerDelegate {
    func didAddNewCard() {
        creditCardManager?.loadCardsForCurrentUser()
        tableView.reloadData()
    }
}
