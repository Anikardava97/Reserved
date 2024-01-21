//
//  OpenHoursViewController.swift
//  Reserved
//
//  Created by Ani's Mac on 21.01.24.
//

import UIKit
import Lottie

struct DaySchedule {
    let day: String
    let hours: String
}

final class OpenHoursViewController: UIViewController {
    // MARK: - Properties
    private var animationView: LottieAnimationView!
    
    private let mainStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 26
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let openHoursLabel: UILabel = {
        let label = UILabel()
        label.text = "Open hours"
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        label.textColor = .white
        return label
    }()
    
    private let dayScheduleStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 16
        return stackView
    }()
    
    private let daySchedules = [
        DaySchedule(day: "Monday",
                    hours: "\(mockRestaurant.openHours.monday.startTime.rawValue) - \(mockRestaurant.openHours.monday.endTime.rawValue)"),
        DaySchedule(day: "Tuesday",
                    hours: "\(mockRestaurant.openHours.tuesday.startTime.rawValue) - \(mockRestaurant.openHours.tuesday.endTime.rawValue)"),
        DaySchedule(day: "Wednesday",
                    hours: "\(mockRestaurant.openHours.wednesday.startTime.rawValue) - \(mockRestaurant.openHours.wednesday.endTime.rawValue)"),
        DaySchedule(day: "Thursday",
                    hours: "\(mockRestaurant.openHours.thursday.startTime.rawValue) - \(mockRestaurant.openHours.thursday.endTime.rawValue)"),
        DaySchedule(day: "Friday",
                    hours: "\(mockRestaurant.openHours.friday.startTime.rawValue) - \(mockRestaurant.openHours.friday.endTime.rawValue)"),
        DaySchedule(day: "Saturday",
                    hours: "\(mockRestaurant.openHours.saturday.startTime.rawValue) - \(mockRestaurant.openHours.saturday.endTime.rawValue)"),
        DaySchedule(day: "Sunday",
                    hours: "\(mockRestaurant.openHours.sunday.startTime.rawValue) - \(mockRestaurant.openHours.sunday.endTime.rawValue)")
    ]
    
    // MARK: - ViewLifeCycles
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        animationView.stop()
    }
    
    // MARK: - Private Methods
    private func setup() {
        setupBackground()
        setupSubviews()
        setupMainStackViewConstraints()
        setupDayScheduleLabels()
        setupAnimationView()
    }
    
    private func setupBackground() {
        view.backgroundColor = .customBackgroundColor
    }
    
    private func setupSubviews() {
        view.addSubview(mainStackView)
        mainStackView.addArrangedSubview(openHoursLabel)
        mainStackView.addArrangedSubview(dayScheduleStackView)
    }
    
    private func setupMainStackViewConstraints() {
        NSLayoutConstraint.activate([
            mainStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            mainStackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            mainStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 12),
            mainStackView.bottomAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
    
    private func setupDayScheduleLabels() {
        for daySchedule in daySchedules {
            let (dayLabel, timeLabel) = createDayScheduleLabels(daySchedule)
            
            if daySchedule.day.lowercased() == RestaurantHoursManager.currentDayOfWeek() {
                dayLabel.textColor = .customGreenColor
                timeLabel.textColor = .customGreenColor
            }
            
            dayScheduleStackView.addArrangedSubview(dayLabel)
            dayScheduleStackView.addArrangedSubview(timeLabel)
            
            NSLayoutConstraint.activate([
                timeLabel.topAnchor.constraint(equalTo: dayLabel.bottomAnchor, constant: 10)
            ])
        }
    }
    
    private func createDayScheduleLabels(_ daySchedule: DaySchedule) -> (dayLabel: UILabel, timeLabel: UILabel) {
        let dayLabel = UILabel()
        dayLabel.textColor = .white
        dayLabel.text = daySchedule.day
        dayLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        
        let timeLabel = UILabel()
        timeLabel.textColor = .white.withAlphaComponent(0.8)
        timeLabel.text = daySchedule.hours
        timeLabel.font = UIFont.systemFont(ofSize: 14)
        
        return (dayLabel, timeLabel)
    }
    
    private func setupAnimationView() {
        animationView = .init(name: "Animation - 1705836632095")
        animationView.contentMode = .scaleAspectFit
        animationView.loopMode = .loop
        animationView.animationSpeed = 1.0
        mainStackView.addArrangedSubview(animationView)
        
        animationView.play()
    }
}

#Preview {
    OpenHoursViewController()
}
