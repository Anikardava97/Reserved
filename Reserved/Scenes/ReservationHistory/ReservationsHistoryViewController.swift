//
//  ReservationsHistoryViewController.swift
//  Reserved
//
//  Created by Ani's Mac on 01.02.24.
//

import UIKit

final class ReservationsHistoryViewController: UIViewController {
    // MARK: - Properties
    let emptyStateViewController = EmptyStateViewController(
        title: "Start your culinary journey",
        description: "Your reservation history is empty. Start your journey by booking a table.",
        animationName: "Animation - 1706506120281")
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private let scrollStackViewContainer: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 18
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    // MARK: - ViewLifeCycles
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        showReservationsHistory()
    }
    
    // MARK: - Methods
    private func setup() {
        setupBackground()
        setupScrollView()
        setupSubviews()
        setupConstraints()
        requestNotificationPermissions()
    }
    
    private func setupBackground() {
        view.backgroundColor = .customBackgroundColor
    }
    
    private func setupSubviews() {
        view.addSubview(scrollView)
        scrollView.addSubview(scrollStackViewContainer)
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
            scrollStackViewContainer.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
    }
    
    private func setupScrollView() {
        scrollView.showsVerticalScrollIndicator = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func showReservationsHistory() {
        DispatchQueue.main.async { [weak self] in
            self?.scrollStackViewContainer.arrangedSubviews.forEach { $0.removeFromSuperview() }
            
            let reservations = ReservationManager.shared.getAllReservations()
            
            if reservations.isEmpty {
                self?.showEmptyState()
            } else {
                self?.hideEmptyState()
                for (index, reservation) in reservations.enumerated() {
                    if let detailsSectionView = self?.configureDetailsSection(with: reservation, index: index) {
                        self?.scrollStackViewContainer.addArrangedSubview(detailsSectionView)
                    }
                }
            }
        }
    }
    
    private func configureDetailsSection(with reservation: MyReservation, index: Int) -> UIView {
        let view = createSectionWrapperView()
        
        let reminderButton = UIButton()
        if let reminderIcon = UIImage(systemName: "bell.fill") {
            reminderButton.setImage(reminderIcon, for: .normal)
        }
        reminderButton.tintColor = .white.withAlphaComponent(0.8)
        reminderButton.addTarget(self, action: #selector(setReminder(_:)), for: .touchUpInside)
        reminderButton.tag = index
        reminderButton.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(reminderButton)
        
        NSLayoutConstraint.activate([
            reminderButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            reminderButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 24),
            reminderButton.widthAnchor.constraint(equalToConstant: 30),
            reminderButton.heightAnchor.constraint(equalToConstant: 30)
        ])
        
        let cancelButton = UIButton()
        cancelButton.setTitle("Cancel Reservation", for: .normal)
        cancelButton.setTitleColor(.customAccentColor, for: .normal)
        cancelButton.tag = index
        cancelButton.addTarget(self, action: #selector(cancelReservation(_:)), for: .touchUpInside)
        
        let restaurantNameLabel: UILabel = {
            let label = UILabel()
            label.text = reservation.restaurantName
            label.font = UIFont.systemFont(ofSize: 24, weight: .medium)
            label.numberOfLines = 0
            label.textColor = .white
            label.textAlignment = .center
            return label
        }()
        
        let dateLabel = createLabelWithIcon(title: "Date", value: reservation.reservationDate, iconName: "calendar")
        let timeLabel = createLabelWithIcon(title: "Time", value: reservation.reservationTime, iconName: "clock")
        let guestsLabel = createLabelWithIcon(title: "Guests", value: "\(reservation.guestsCount) Guests", iconName: "person.2")
        
        let stackView = UIStackView(arrangedSubviews: [restaurantNameLabel, dateLabel, timeLabel, guestsLabel])
        stackView.axis = .vertical
        stackView.spacing = 24
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(stackView)
        stackView.addArrangedSubview(cancelButton)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.topAnchor, constant: 24),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32),
            stackView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -24)
        ])
        return view
    }
    
    private func createLabelWithIcon(title: String, value: String, iconName: String) -> UIView {
        let containerView = UIView()
        
        let label = UILabel()
        label.text = "\(title) : \(value)"
        label.font = UIFont.systemFont(ofSize: 18)
        label.textColor = .white
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        
        if let systemIconImage = UIImage(systemName: iconName) {
            let iconImageView = UIImageView(image: systemIconImage)
            iconImageView.tintColor = .white
            iconImageView.contentMode = .scaleAspectFit
            iconImageView.translatesAutoresizingMaskIntoConstraints = false
            
            containerView.addSubview(iconImageView)
            containerView.addSubview(label)
            
            NSLayoutConstraint.activate([
                iconImageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
                iconImageView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
                iconImageView.widthAnchor.constraint(equalToConstant: 24),
                iconImageView.heightAnchor.constraint(equalToConstant: 24),
                
                label.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 12),
                label.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
                label.topAnchor.constraint(equalTo: containerView.topAnchor),
                label.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            ])
        }
        return containerView
    }
    
    private func createSectionWrapperView() -> UIView {
        let view = UIView()
        view.backgroundColor = .darkGray.withAlphaComponent(0.1)
        view.layer.cornerRadius = 10
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
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
    
    private func requestNotificationPermissions() {
        NotificationManager.shared.requestAuthorization { granted in
            DispatchQueue.main.async {
                if granted {
                    print("Notifications permission granted.")
                } else {
                    print("Notifications permission denied.")
                }
            }
        }
    }
    
    // MARK: - Actions
    @objc private func cancelReservation(_ sender: UIButton) {
        let index = sender.tag
        if index < ReservationManager.shared.myReservations.count {
            let alertController = UIAlertController(title: "Cancel Reservation", message: "Are you sure you want to cancel this reservation?", preferredStyle: .alert)
            
            alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            alertController.addAction(UIAlertAction(title: "Confirm", style: .destructive) { [weak self] _ in
                ReservationManager.shared.cancelReservation(atIndex: index)
                self?.showReservationsHistory()
            })
            present(alertController, animated: true, completion: nil)
        } else {
            print("Invalid reservation index.")
        }
    }
    
    @objc private func setReminder(_ sender: UIButton) {
        let index = sender.tag
        guard index < ReservationManager.shared.myReservations.count else { return }
        
        let reservation = ReservationManager.shared.myReservations[index]
        let alertController = UIAlertController(title: "Set Reminder 🔔", message: "Do you want to set a reminder for this reservation?", preferredStyle: .alert)
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alertController.addAction(UIAlertAction(title: "Yes", style: .default) { _ in
            NotificationManager.shared.scheduleNotification(for: reservation)
        })
        present(alertController, animated: true)
    }
}

