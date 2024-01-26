//
//  ReservationViewController.swift
//  Reserved
//
//  Created by Ani's Mac on 21.01.24.
//

import UIKit

final class ReservationViewController: UIViewController {
    // MARK: - Properties
    private var guestCount = 2
    var selectedRestaurant: Restaurant?
    private var selectedDate: Date?
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
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
        label.text = "\(guestCount)"
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
    
    // MARK: - Body
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    private func setup() {
        setupBackground()
        setupScrollView()
        setupSelectedRestaurantImageAndName()
        setupSubviews()
        setupConstraints()
        setupDateButton()
        setupTimeButton()
    }
    
    private func setupBackground() {
        view.backgroundColor = .customBackgroundColor
    }
    
    private func setupScrollView() {
        scrollView.showsVerticalScrollIndicator = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func setupSelectedRestaurantImageAndName() {
        if let restaurant = selectedRestaurant {
            setRestaurantImage(from: restaurant.mainImageURL)
            setFormattedRestaurantName(restaurant.name.uppercased())
        }
    }
    
    private func setFormattedRestaurantName(_ name: String) {
        let formattedName = name.map { String($0) }.joined(separator: " ")
        restaurantNameLabel.text = formattedName
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
        
        restaurantImageView.addSubview(overlayView)
        overlayView.addSubview(reservingMessageStackView)
        
        dateSectionView.addSubview(selectDateStackView)
        mainStackView.addArrangedSubview(dateSectionView)
        
        timeSectionView.addSubview(selectTimeStackView)
        mainStackView.addArrangedSubview(timeSectionView)
        
        selectGuestsStackView.addArrangedSubview(guestControlStackView)
        
        guestsSectionView.addSubview(selectGuestsStackView)
        mainStackView.addArrangedSubview(guestsSectionView)
        mainStackView.addArrangedSubview(nextButton)
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
            scrollStackViewContainer.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            restaurantImageView.heightAnchor.constraint(equalToConstant: 260),
            
            overlayView.leadingAnchor.constraint(equalTo: restaurantImageView.leadingAnchor),
            overlayView.trailingAnchor.constraint(equalTo: restaurantImageView.trailingAnchor),
            overlayView.topAnchor.constraint(equalTo: restaurantImageView.topAnchor),
            overlayView.bottomAnchor.constraint(equalTo: restaurantImageView.bottomAnchor),
            
            reservingMessageStackView.centerXAnchor.constraint(equalTo: overlayView.centerXAnchor),
            reservingMessageStackView.centerYAnchor.constraint(equalTo: overlayView.centerYAnchor),
            
            selectDateButton.heightAnchor.constraint(equalToConstant: 48),
            selectTimeButton.heightAnchor.constraint(equalToConstant: 48),
            
            selectDateStackView.centerXAnchor.constraint(equalTo: dateSectionView.centerXAnchor),
            selectDateStackView.topAnchor.constraint(equalTo: dateSectionView.topAnchor, constant: 16),
            selectDateStackView.bottomAnchor.constraint(equalTo: dateSectionView.bottomAnchor, constant: -16),
            
            selectTimeStackView.centerXAnchor.constraint(equalTo: timeSectionView.centerXAnchor),
            selectTimeStackView.topAnchor.constraint(equalTo: timeSectionView.topAnchor, constant: 16),
            selectTimeStackView.bottomAnchor.constraint(equalTo: timeSectionView.bottomAnchor, constant: -16),
            
            selectGuestsStackView.centerXAnchor.constraint(equalTo: guestsSectionView.centerXAnchor),
            selectGuestsStackView.topAnchor.constraint(equalTo: guestsSectionView.topAnchor, constant: 16),
            selectGuestsStackView.bottomAnchor.constraint(equalTo: guestsSectionView.bottomAnchor, constant: -16),
        ])
    }
    
    private func createSectionWrapperView() -> UIView {
        let view = UIView()
        view.backgroundColor = .darkGray.withAlphaComponent(0.1)
        view.layer.cornerRadius = 10
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }
    
    private func setupDateButton() {
        selectDateButton.addTarget(self, action: #selector(selectDateButtonDidTap), for: .touchUpInside)
    }
    
    private func setupTimeButton() {
        selectTimeButton.addTarget(self, action: #selector(selectTimeButtonDidTap), for: .touchUpInside)
    }
    
    @objc private func nextButtonDidTap() {
        if selectedDate == nil {
            showDateSelectionAlert()
        } else {
            validateReservation()
        }
    }
    
    private func showDateSelectionAlert() {
        let alert = UIAlertController(
            title: "Select Valid Date 😳",
            message: "Please choose your desired reservation date.",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    private func validateReservation() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "HH:mm:ss"
        
        guard let selectedDate = selectedDate,
              let selectedTimeText = selectTimeButton.title(for: .normal),
              let selectedGuests = Int(guestCountLabel.text ?? "2"),
              let selectedRestaurant = selectedRestaurant,
              let reservations = selectedRestaurant.reservations else {
            return
        }
        
        let formattedDate = dateFormatter.string(from: selectedDate)
        let formattedTime = timeFormatter.string(from: timeFormatter.date(from: selectedTimeText + ":00") ?? Date())
        
        let reservedTables = reservations.filter { reservation in
            return reservation.date == formattedDate && reservation.time == formattedTime && reservation.guestCount == selectedGuests
        }
        
        if reservedTables.count >= 2 {
            showNoAvailableTablesAlert()
        } else {
            performReservation()
        }
    }
    
    private func showNoAvailableTablesAlert() {
        let alert = UIAlertController(
            title: "No Available Tables😔",
            message: "There are no available tables for the selected date, time, and guest count. Please choose a different option👩🏻‍🍳",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    private func performReservation() {
        let tablesViewController = TablesViewController()
        tablesViewController.selectedDate = selectDateButton.title(for: .normal)
        tablesViewController.selectedTime = selectTimeButton.title(for: .normal)
        tablesViewController.selectedGuests = Int(guestCountLabel.text ?? "2")
        navigationController?.pushViewController(tablesViewController, animated: true)
    }
    
    func getTodayOpenHours(for restaurant: Restaurant) -> (open: Date?, close: Date?) {
        let todayHours = RestaurantHoursManager.getTodaysOpeningHours(from: restaurant)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "h:mm a"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        
        let calendar = Calendar.current
        let now = Date()
        let currentYear = calendar.component(.year, from: now)
        let currentMonth = calendar.component(.month, from: now)
        let currentDay = calendar.component(.day, from: now)
        
        let hoursArray = todayHours.components(separatedBy: " - ")
        guard hoursArray.count == 2 else { return (nil, nil) }
        
        let openTimeStr = hoursArray[0]
        let closeTimeStr = hoursArray[1]
        
        guard let openTime = dateFormatter.date(from: openTimeStr),
              let closeTime = dateFormatter.date(from: closeTimeStr) else {
            return (nil, nil)
        }
        
        var openDateComponents = calendar.dateComponents([.hour, .minute], from: openTime)
        openDateComponents.year = currentYear
        openDateComponents.month = currentMonth
        openDateComponents.day = currentDay
        
        var closeDateComponents = calendar.dateComponents([.hour, .minute], from: closeTime)
        closeDateComponents.year = currentYear
        closeDateComponents.month = currentMonth
        closeDateComponents.day = currentDay
        
        if closeTime < openTime {
            closeDateComponents.day = currentDay + 1
        }
        
        let finalOpenDate = calendar.date(from: openDateComponents)
        let finalCloseDate = calendar.date(from: closeDateComponents)
        
        return (finalOpenDate, finalCloseDate)
    }
    
    private func dateDidChange(datePicker: UIDatePicker) {
        let selectedDate = datePicker.date
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        selectDateButton.setTitle(dateFormatter.string(from: selectedDate), for: .normal)
    }
    
    private func timeDidChange(timePicker: UIDatePicker) {
        let selectedDate = timePicker.date
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = .short
        selectTimeButton.setTitle(dateFormatter.string(from: selectedDate), for: .normal)
    }
    
    @objc private func selectDateButtonDidTap() {
        let datePicker = UIDatePicker()
        datePicker.preferredDatePickerStyle = .inline
        datePicker.datePickerMode = .date
        
        datePicker.minimumDate = Date()
        
        
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
            self.selectedDate = datePicker.date
            self.dateDidChange(datePicker: datePicker)
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc private func selectTimeButtonDidTap() {
        let timePicker = UIDatePicker()
        timePicker.preferredDatePickerStyle = .wheels
        timePicker.datePickerMode = .time
        
        if let restaurant = selectedRestaurant {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "h:mm a"
            dateFormatter.locale = Locale(identifier: "en_US_POSIX")
            
            let todayHours = RestaurantHoursManager.getTodaysOpeningHours(from: restaurant)
            let hoursArray = todayHours.components(separatedBy: " - ")
            guard hoursArray.count == 2,
                  let openTime = dateFormatter.date(from: hoursArray[0]),
                  let closeTime = dateFormatter.date(from: hoursArray[1]) else {
                return
            }
            
            let now = Date()
            let calendar = Calendar.current
            
            let openDateTime = calendar.date(bySettingHour: calendar.component(.hour, from: openTime),
                                             minute: calendar.component(.minute, from: openTime),
                                             second: 0,
                                             of: now)!
            
            var closeDateTime = calendar.date(bySettingHour: calendar.component(.hour, from: closeTime),
                                              minute: calendar.component(.minute, from: closeTime),
                                              second: 0,
                                              of: now)!
            
            if closeTime < openTime {
                closeDateTime = calendar.date(byAdding: .day, value: 1, to: closeDateTime)!
            }
            
            timePicker.minimumDate = openDateTime
            timePicker.maximumDate = closeDateTime
        }
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
            self.timeDidChange(timePicker: timePicker)
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc private func incrementGuestCount() {
        if guestCount < 12 {
            guestCount += 1
            guestCountLabel.text = "\(guestCount)"
        }
    }
    
    @objc private func decrementGuestCount() {
        if guestCount > 1 {
            guestCount -= 1
            guestCountLabel.text = "\(guestCount)"
        }
    }
    
    private func updateGuestCountDisplay() {
        guestCountLabel.text = "\(guestCount)"
    }
}

#Preview {
    ReservationViewController()
}
