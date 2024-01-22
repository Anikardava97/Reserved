//
//  ReservationViewController.swift
//  Reserved
//
//  Created by Ani's Mac on 21.01.24.
//

import UIKit

class ReservationViewController: UIViewController {
    // MARK: - Properties
    private var guestCount = 2
    
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
        imageView.image = UIImage(named: "Stamba1")
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
        label.text = mockRestaurant.name
        label.font = UIFont.systemFont(ofSize: 20, weight: .medium)
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
    
    private let nextButton = MainButtonComponent(
        text: "Next",
        textColor: .white,
        backgroundColor: .customAccentColor
    )
    
    // MARK: - Body
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    private func setup() {
        setupBackground()
        setupSubviews()
        setupConstraints()
        setupDateButton()
        setupTimeButton()
    }
    
    private func setupBackground() {
        view.backgroundColor = .customBackgroundColor
    }
    
    private func setupSubviews() {
        view.addSubview(mainStackView)
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
            mainStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mainStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            mainStackView.topAnchor.constraint(equalTo: view.topAnchor),
            
            restaurantImageView.heightAnchor.constraint(equalToConstant: 260),
            
            overlayView.leadingAnchor.constraint(equalTo: restaurantImageView.leadingAnchor),
            overlayView.trailingAnchor.constraint(equalTo: restaurantImageView.trailingAnchor),
            overlayView.topAnchor.constraint(equalTo: restaurantImageView.topAnchor),
            overlayView.bottomAnchor.constraint(equalTo: restaurantImageView.bottomAnchor),
            
            reservingMessageStackView.centerXAnchor.constraint(equalTo: overlayView.centerXAnchor),
            reservingMessageStackView.centerYAnchor.constraint(equalTo: overlayView.centerYAnchor),
            
            selectDateButton.heightAnchor.constraint(equalToConstant: 48),
            selectTimeButton.heightAnchor.constraint(equalToConstant: 48),
            
            dateSectionView.leadingAnchor.constraint(equalTo: mainStackView.leadingAnchor, constant: 16),
            dateSectionView.trailingAnchor.constraint(equalTo: mainStackView.trailingAnchor, constant: -16),
            selectDateStackView.centerXAnchor.constraint(equalTo: dateSectionView.centerXAnchor),
            selectDateStackView.topAnchor.constraint(equalTo: dateSectionView.topAnchor, constant: 16),
            selectDateStackView.bottomAnchor.constraint(equalTo: dateSectionView.bottomAnchor, constant: -16),
            
            timeSectionView.leadingAnchor.constraint(equalTo: mainStackView.leadingAnchor, constant: 16),
            timeSectionView.trailingAnchor.constraint(equalTo: mainStackView.trailingAnchor, constant: -16),
            selectTimeStackView.centerXAnchor.constraint(equalTo: timeSectionView.centerXAnchor),
            selectTimeStackView.topAnchor.constraint(equalTo: timeSectionView.topAnchor, constant: 16),
            selectTimeStackView.bottomAnchor.constraint(equalTo: timeSectionView.bottomAnchor, constant: -16),
            
            guestsSectionView.leadingAnchor.constraint(equalTo: mainStackView.leadingAnchor, constant: 16),
            guestsSectionView.trailingAnchor.constraint(equalTo: mainStackView.trailingAnchor, constant: -16),
            selectGuestsStackView.centerXAnchor.constraint(equalTo: guestsSectionView.centerXAnchor),
            selectGuestsStackView.topAnchor.constraint(equalTo: guestsSectionView.topAnchor, constant: 16),
            selectGuestsStackView.bottomAnchor.constraint(equalTo: guestsSectionView.bottomAnchor, constant: -16),
            
            nextButton.leadingAnchor.constraint(equalTo: mainStackView.leadingAnchor, constant: 16),
            nextButton.trailingAnchor.constraint(equalTo: mainStackView.trailingAnchor, constant: -16)
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
