//
//  ReservationViewController.swift
//  Reserved
//
//  Created by Ani's Mac on 21.01.24.
//

import UIKit

final class ReservationViewController: UIViewController {
    // MARK: - Properties
    var selectedRestaurant: Restaurant?
    
    private lazy var viewModel: ReservationViewModel = {
        guard let selectedRestaurant else {
            fatalError("Selected restaurant is nil.")
        }
        return ReservationViewModel(selectedRestaurant: selectedRestaurant)
    }()
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
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
    
    private let mainStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 24
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let overlayView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var dateSectionView: UIView = {
        let view = createSectionWrapperView()
        return view
    }()
    
    private lazy var timeSectionView: UIView = {
        let view = createSectionWrapperView()
        return view
    }()
    
    private lazy var guestsSectionView: UIView = {
        let view = createSectionWrapperView()
        return view
    }()
    
    private lazy var reservingMessageStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [restaurantMessageLabel, restaurantNameLabel])
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let restaurantImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 32
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let restaurantMessageLabel: UILabel = {
        let label = UILabel()
        label.text = "Your table awaits at"
        label.font = UIFont.systemFont(ofSize: 24, weight: .medium)
        label.textColor = .white
        return label
    }()
    
    private let restaurantNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 30, weight: .medium)
        label.textColor = .white
        return label
    }()
    
    private lazy var selectDateStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [selectDateTitleLabel, selectDateButton])
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let selectDateTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "When would you like to visit?"
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()
    
    private let selectDateButton: UIButton = {
        let button = UIButton(type: .system)
        
        var configuration = UIButton.Configuration.filled()
        configuration.cornerStyle = .capsule
        configuration.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16)
        
        configuration.image = UIImage(systemName: "calendar")
        configuration.imagePlacement = .leading
        configuration.imagePadding = 8
        
        button.configuration = configuration
        button.setTitle("Tomorrow", for: .normal)
        button.tintColor = .darkGray.withAlphaComponent(0.2)
        return button
    }()
    
    private lazy var selectTimeStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [selectTimeTitleLabel, selectTimeButton])
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let selectTimeTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "What time should we expect you?"
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()
    
    private let selectTimeButton: UIButton = {
        let button = UIButton(type: .system)
        
        var configuration = UIButton.Configuration.filled()
        configuration.cornerStyle = .capsule
        configuration.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16)
        
        configuration.image = UIImage(systemName: "clock")
        configuration.imagePlacement = .leading
        configuration.imagePadding = 8
        
        button.configuration = configuration
        button.setTitle("20:00", for: .normal)
        button.tintColor = .darkGray.withAlphaComponent(0.2)
        return button
    }()
    
    private lazy var guestControlStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [decrementGuestButton, guestCountLabel, incrementGuestButton])
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        stackView.alignment = .center
        stackView.spacing = 8
        return stackView
    }()
    
    private lazy var guestCountLabel: UILabel = {
        let label = UILabel()
        label.text = "\(viewModel.formattedGuestCount)"
        label.font = UIFont.systemFont(ofSize: 18)
        label.textAlignment = .center
        label.textColor = .white
        return label
    }()
    
    private lazy var incrementGuestButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("+", for: .normal)
        button.tintColor = .white
        button.addTarget(self, action: #selector(incrementGuestCount), for: .touchUpInside)
        return button
    }()
    
    private lazy var decrementGuestButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("-", for: .normal)
        button.tintColor = .white
        button.addTarget(self, action: #selector(decrementGuestCount), for: .touchUpInside)
        return button
    }()
    
    private lazy var selectGuestsStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [selectGuestsTitleLabel, guestControlStackView])
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let selectGuestsTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "How big is your party?"
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()
    
    private lazy var nextButton: MainButtonComponent = {
        let button = MainButtonComponent(
            text: "Next",
            textColor: .white,
            backgroundColor: .customAccentColor
        )
        button.addTarget(self, action: #selector(nextButtonDidTap), for: .touchUpInside)
        return button
    }()
    
    // MARK: - ViewLifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    // MARK: - Methods
    private func setup() {
        setupBackground()
        setupSelectedRestaurantImageAndName()
        setupSubviews()
        setupConstraints()
        setupDateButton()
        setupTimeButton()
    }
    
    private func setupBackground() {
        view.backgroundColor = .customBackgroundColor
    }
    
    private func setupSelectedRestaurantImageAndName() {
        if let restaurant = viewModel.selectedRestaurant {
            if let imageURL = viewModel.restaurantImageURL { setRestaurantImage(from: imageURL) }
            setFormattedRestaurantName(restaurant.name.uppercased())
        }
    }
    
    private func setFormattedRestaurantName(_ name: String) {
        restaurantNameLabel.text = viewModel.formattedRestaurantName
    }
    
    private func setRestaurantImage(from url: String) {
        NetworkManager.shared.downloadImage(from: url) { [weak self] image in
            DispatchQueue.main.async {
                self?.restaurantImageView.image = image
            }
        }
    }
    
    private func setupSubviews() {
        view.addSubview(scrollView)
        scrollView.addSubview(scrollStackViewContainer)
        scrollStackViewContainer.addArrangedSubview(mainStackView)
        
        mainStackView.addArrangedSubview(restaurantImageView)
        mainStackView.addArrangedSubview(dateSectionView)
        mainStackView.addArrangedSubview(timeSectionView)
        mainStackView.addArrangedSubview(guestsSectionView)
        mainStackView.addArrangedSubview(nextButton)
        
        restaurantImageView.addSubview(overlayView)
        overlayView.addSubview(reservingMessageStackView)
        dateSectionView.addSubview(selectDateStackView)
        timeSectionView.addSubview(selectTimeStackView)
        selectGuestsStackView.addArrangedSubview(guestControlStackView)
        guestsSectionView.addSubview(selectGuestsStackView)
    }
    
    private func setupConstraints() {
        setupScrollViewAndScrollStackViewConstraints()
        setupRestaurantImageAndMessageConstraints()
        setupDateAndTimeButtonsConstraints()
        setupDateStackViewConstraints()
        setupTimeStackViewConstraints()
        setupGuestsStackViewConstraints()
    }
    
    private func setupScrollViewAndScrollStackViewConstraints() {
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
    
    private func setupRestaurantImageAndMessageConstraints() {
        NSLayoutConstraint.activate([
            restaurantImageView.heightAnchor.constraint(equalToConstant: 260),
            
            overlayView.leadingAnchor.constraint(equalTo: restaurantImageView.leadingAnchor),
            overlayView.trailingAnchor.constraint(equalTo: restaurantImageView.trailingAnchor),
            overlayView.topAnchor.constraint(equalTo: restaurantImageView.topAnchor),
            overlayView.bottomAnchor.constraint(equalTo: restaurantImageView.bottomAnchor),
            
            reservingMessageStackView.centerXAnchor.constraint(equalTo: overlayView.centerXAnchor),
            reservingMessageStackView.centerYAnchor.constraint(equalTo: overlayView.centerYAnchor)
        ])
    }
    
    private func setupDateAndTimeButtonsConstraints() {
        selectDateButton.heightAnchor.constraint(equalToConstant: 48).isActive = true
        selectTimeButton.heightAnchor.constraint(equalToConstant: 48).isActive = true
    }
    
    private func setupDateStackViewConstraints() {
        NSLayoutConstraint.activate([
            selectDateStackView.centerXAnchor.constraint(equalTo: dateSectionView.centerXAnchor),
            selectDateStackView.topAnchor.constraint(equalTo: dateSectionView.topAnchor, constant: 16),
            selectDateStackView.bottomAnchor.constraint(equalTo: dateSectionView.bottomAnchor, constant: -16)
        ])
    }
    
    private func setupTimeStackViewConstraints() {
        NSLayoutConstraint.activate([
            selectTimeStackView.centerXAnchor.constraint(equalTo: timeSectionView.centerXAnchor),
            selectTimeStackView.topAnchor.constraint(equalTo: timeSectionView.topAnchor, constant: 16),
            selectTimeStackView.bottomAnchor.constraint(equalTo: timeSectionView.bottomAnchor, constant: -16)
        ])
    }
    
    private func setupGuestsStackViewConstraints() {
        NSLayoutConstraint.activate([
            selectGuestsStackView.centerXAnchor.constraint(equalTo: guestsSectionView.centerXAnchor),
            selectGuestsStackView.topAnchor.constraint(equalTo: guestsSectionView.topAnchor, constant: 16),
            selectGuestsStackView.bottomAnchor.constraint(equalTo: guestsSectionView.bottomAnchor, constant: -16)
        ])
    }
    
    private func createSectionWrapperView() -> UIView {
        let view = UIView()
        view.backgroundColor = .darkGray.withAlphaComponent(0.1)
        view.layer.cornerRadius = 10
        view.clipsToBounds = true
        return view
    }
    
    private func setupDateButton() {
        selectDateButton.addTarget(self, action: #selector(selectDateButtonDidTap), for: .touchUpInside)
    }
    
    private func setupTimeButton() {
        selectTimeButton.addTarget(self, action: #selector(selectTimeButtonDidTap), for: .touchUpInside)
    }
    
    private func performReservation() {
        guard let selectedDate = selectDateButton.title(for: .normal),
              let selectedTime = selectTimeButton.title(for: .normal),
              let selectedGuests = Int(guestCountLabel.text ?? "2"),
              let selectedRestaurant = viewModel.selectedRestaurant else { return }
        
        let tablesViewModel = TablesViewModel(
            selectedRestaurant: selectedRestaurant,
            selectedDate: selectedDate,
            selectedTime: selectedTime,
            selectedGuests: selectedGuests
        )
        let tablesViewController = TablesViewController()
        tablesViewController.setup(with: tablesViewModel)
        navigationController?.pushViewController(tablesViewController, animated: true)
    }
    
    private func dateDidChange(datePicker: UIDatePicker) {
        let selectedDate = datePicker.date
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long
        selectDateButton.setTitle(dateFormatter.string(from: selectedDate), for: .normal)
    }
    
    private func timeDidChange(timePicker: UIDatePicker) {
        let selectedDate = timePicker.date
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = .short
        dateFormatter.dateFormat = "HH:mm"
        selectTimeButton.setTitle(dateFormatter.string(from: selectedDate), for: .normal)
    }
    
    private func updateGuestCountDisplay() {
        guestCountLabel.text = "\(viewModel.guestCount)"
    }
    
    // MARK: - Actions
    @objc private func nextButtonDidTap() {
        let validation = viewModel.validateReservation(
            selectedDate: viewModel.selectedDate,
            selectedTimeText: selectTimeButton.title(for: .normal),
            selectedGuests: Int(guestCountLabel.text ?? "2"),
            reservations: viewModel.selectedRestaurant?.reservations
        )
        switch validation {
        case .success:
            performReservation()
        case .failure:
            AlertManager.shared.showAlert(from: self, type: .noAvailableTables)
        }
    }
    
    @objc private func selectDateButtonDidTap() {
        let datePicker = UIDatePicker()
        datePicker.preferredDatePickerStyle = .inline
        datePicker.datePickerMode = .date
        
        if let tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: Date()) {
            datePicker.minimumDate = tomorrow
        }
        
        let alert = UIAlertController(title: "Select Date", message: "", preferredStyle: .actionSheet)
        alert.view.tintColor = .customAccentColor
        alert.view.addSubview(datePicker)
        
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            datePicker.centerXAnchor.constraint(equalTo: alert.view.centerXAnchor),
            datePicker.topAnchor.constraint(equalTo: alert.view.topAnchor, constant: 20),
            datePicker.bottomAnchor.constraint(equalTo: alert.view.bottomAnchor, constant: -40)
        ])
        
        alert.addAction(UIAlertAction(title: "Done", style: .default, handler: { _ in
            self.viewModel.selectedDate = datePicker.date
            self.dateDidChange(datePicker: datePicker)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc private func selectTimeButtonDidTap() {
        let timePicker = UIDatePicker()
        timePicker.preferredDatePickerStyle = .wheels
        timePicker.datePickerMode = .time
        timePicker.minuteInterval = 30
        
        let alert = UIAlertController(title: "Select Time", message: "", preferredStyle: .alert)
        alert.view.tintColor = .customAccentColor
        alert.view.addSubview(timePicker)
        
        timePicker.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            timePicker.centerXAnchor.constraint(equalTo: alert.view.centerXAnchor),
            timePicker.topAnchor.constraint(equalTo: alert.view.topAnchor, constant: 20),
            timePicker.bottomAnchor.constraint(equalTo: alert.view.bottomAnchor, constant: -40)
        ])
        
        alert.addAction(UIAlertAction(title: "Done", style: .default, handler: { _ in
            let selectedTime = timePicker.date
            guard let restaurant = self.viewModel.selectedRestaurant else { return }
            
            if self.viewModel.isValidTime(selectedTime, for: restaurant) {
                self.timeDidChange(timePicker: timePicker)
            } else {
                AlertManager.shared.showAlert(from: self, type: .invalidTime)
            }
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc private func incrementGuestCount() {
        viewModel.incrementGuestCount()
        guestCountLabel.text = "\(viewModel.guestCount)"
    }
    
    @objc private func decrementGuestCount() {
        viewModel.decrementGuestCount()
        guestCountLabel.text = "\(viewModel.guestCount)"
    }
}
