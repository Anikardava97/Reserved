//
//  RestaurantDetailsViewController.swift
//  Reserved
//
//  Created by Ani's Mac on 20.01.24.
//

import UIKit
import SafariServices
import MapKit

final class RestaurantDetailsViewController: UIViewController {
    // MARK: - Properties
    private var viewModel: RestaurantDetailsViewModel?
    private var restaurant: Restaurant?
    private var currentCellIndex = 0
    
    private let imagePageControl: UIPageControl = {
        let pageControl = UIPageControl()
        return pageControl
    }()
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private let scrollStackViewContainer: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.isPagingEnabled = true
        return collectionView
    }()
    
    private let mainStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 24
        return stackView
    }()
    
    private lazy var headerStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [restaurantNameLabel, restaurantCuisineLabel, ratingStackView])
        stackView.axis = .vertical
        stackView.spacing = 12
        stackView.distribution = .fill
        return stackView
    }()
    
    private let restaurantNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        label.textColor = .white
        return label
    }()
    
    private let restaurantCuisineLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .white
        return label
    }()
    
    private lazy var ratingStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [starImageView, restaurantRatingLabel])
        stackView.spacing = 6
        stackView.distribution = .fill
        return stackView
    }()
    
    private let starImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "star.fill")
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .yellow
        return imageView
    }()
    
    private let restaurantRatingLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.textColor = .white
        label.numberOfLines = 1
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        return label
    }()
    
    private lazy var urlStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [menuLabel, websiteLabel, UIView()])
        stackView.spacing = 32
        return stackView
    }()
    
    private let menuLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 14)
        label.isUserInteractionEnabled = true
        
        let underlineAttributedString = NSAttributedString(
            string: "Menu",
            attributes: [
                NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue,
                NSAttributedString.Key.foregroundColor: UIColor.white
            ]
        )
        label.attributedText = underlineAttributedString
        return label
    }()
    
    private let websiteLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 14)
        label.isUserInteractionEnabled = true
        
        let underlineAttributedString = NSAttributedString(
            string: "Visit website",
            attributes: [
                NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue,
                NSAttributedString.Key.foregroundColor: UIColor.white
            ]
        )
        label.attributedText = underlineAttributedString
        return label
    }()
    
    private lazy var openStatusAndChevronStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [openStatusStackView, chevronImageView])
        stackView.distribution = .equalSpacing
        
        stackView.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(openHoursDidTap))
        stackView.addGestureRecognizer(tapGesture)
        return stackView
    }()
    
    private lazy var openStatusStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [restaurantOpenStatusLabel, restaurantOpenHoursLabel])
        stackView.axis = .vertical
        stackView.spacing = 8
        return stackView
    }()
    
    private let restaurantOpenStatusLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        label.textColor = .white
        return label
    }()
    
    private let restaurantOpenHoursLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .white.withAlphaComponent(0.6)
        return label
    }()
    
    private let chevronImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "chevron.right")
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .white
        return imageView
    }()
    
    private lazy var reservationButton: MainButtonComponent = {
        let button = MainButtonComponent(
            text: "Reserve a table",
            textColor: .white,
            backgroundColor: .customAccentColor
        )
        button.addTarget(self, action: #selector(reservationButtonDidTap), for: .touchUpInside)
        return button
    }()
    
    private lazy var aboutSectionStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [aboutSectionTitleLabel, restaurantDescriptionLabel])
        stackView.axis = .vertical
        stackView.spacing = 12
        return stackView
    }()
    
    private let aboutSectionTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "About"
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        label.textColor = .white
        return label
    }()
    
    private lazy var restaurantDescriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .white
        label.numberOfLines = 0
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 6
        
        let attributedText = NSMutableAttributedString(string: viewModel?.description ?? "")
        attributedText.addAttribute(
            NSAttributedString.Key.paragraphStyle,
            value: paragraphStyle,
            range: NSMakeRange(0, attributedText.length)
        )
        label.attributedText = attributedText
        return label
    }()
    
    private lazy var locationSectionStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [locationSectionLabel, locationMapView])
        stackView.axis = .vertical
        stackView.spacing = 12
        return stackView
    }()
    
    private let locationSectionLabel: UILabel = {
        let label = UILabel()
        label.text = "Explore the area"
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        label.textColor = .white
        return label
    }()
    
    private var locationMapView: MKMapView = {
        let mapView = MKMapView()
        mapView.translatesAutoresizingMaskIntoConstraints = false
        mapView.layer.cornerRadius = 8
        return mapView
    }()
    
    private lazy var addressSectionStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [addressTitleStackView, restaurantAddressLabel])
        stackView.axis = .vertical
        stackView.spacing = 12
        return stackView
    }()
    
    private lazy var addressTitleStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [addressIconImageView, addressTitleLabel])
        stackView.spacing = 12
        return stackView
    }()
    
    private let addressIconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "mappin.and.ellipse")
        imageView.tintColor = .white
        return imageView
    }()
    
    private let addressTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Address"
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .white
        return label
    }()
    
    private lazy var restaurantAddressLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .white
        
        let underlineAttributedString = NSAttributedString(
            string: viewModel?.address ?? "",
            attributes: [
                NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue,
                NSAttributedString.Key.foregroundColor: UIColor.white
            ]
        )
        label.attributedText = underlineAttributedString
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(addressLabelDidTap))
        label.isUserInteractionEnabled = true
        label.addGestureRecognizer(tapGesture)
        return label
    }()
    
    private lazy var numberStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [numberTitleStackView, restaurantNumberLabel])
        stackView.axis = .vertical
        stackView.spacing = 12
        return stackView
    }()
    
    private lazy var numberTitleStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [numberIconImageView, numberTitleLabel])
        stackView.spacing = 12
        return stackView
    }()
    
    private let numberIconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "phone.fill")
        imageView.tintColor = .white
        return imageView
    }()
    
    private let numberTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Number"
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .white
        return label
    }()
    
    private lazy var restaurantNumberLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .white
        
        let underlineAttributedString = NSAttributedString(
            string: viewModel?.phoneNumber ?? "",
            attributes: [
                NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue,
                NSAttributedString.Key.foregroundColor: UIColor.white
            ]
        )
        label.attributedText = underlineAttributedString
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(numberLabelDidTap))
        label.isUserInteractionEnabled = true
        label.addGestureRecognizer(tapGesture)
        return label
    }()
    
    // MARK: - ViewLifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    // MARK: - Private Methods
    private func setup() {
        setupBackground()
        setupScrollView()
        setupSubviews()
        setupConstraints()
        setupCollectionView()
        setupImagePageController()
        setupLabelActions()
        setupMapView()
    }
    
    private func setupBackground() {
        view.backgroundColor = .customBackgroundColor
    }
    
    private func setupScrollView() {
        scrollView.showsVerticalScrollIndicator = false
    }
    
    private func setupSubviews() {
        view.addSubview(scrollView)
        scrollView.addSubview(scrollStackViewContainer)
        
        scrollStackViewContainer.addArrangedSubview(collectionView)
        scrollStackViewContainer.addArrangedSubview(imagePageControl)
        scrollStackViewContainer.addArrangedSubview(mainStackView)
        
        mainStackView.addArrangedSubview(headerStackView)
        mainStackView.addArrangedSubview(urlStackView)
        mainStackView.addArrangedSubview(openStatusAndChevronStackView)
        mainStackView.addArrangedSubview(reservationButton)
        mainStackView.addArrangedSubview(aboutSectionStackView)
        mainStackView.addArrangedSubview(locationSectionStackView)
        mainStackView.addArrangedSubview(addressSectionStackView)
        mainStackView.addArrangedSubview(numberStackView)
    }
    
    private func setupConstraints() {
        setupScrollViewAndScrollStackViewConstraints()
        setupCollectionViewConstraints()
        setupImagePageControlConstraints()
        setupMainStackViewConstraints()
        setupStarImageViewConstraints()
        setupLocationMapConstraints()
        setupAddressIconImageViewConstraints()
        setupNumberIconImageViewConstraints()
    }
    
    private func setupScrollViewAndScrollStackViewConstraints() {
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            scrollStackViewContainer.topAnchor.constraint(equalTo: scrollView.topAnchor),
            scrollStackViewContainer.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            scrollStackViewContainer.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            scrollStackViewContainer.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            scrollStackViewContainer.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
    }
    
    private func setupCollectionViewConstraints() {
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: scrollStackViewContainer.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: scrollStackViewContainer.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: scrollStackViewContainer.trailingAnchor),
            collectionView.widthAnchor.constraint(equalTo: scrollStackViewContainer.widthAnchor),
            collectionView.heightAnchor.constraint(equalToConstant: 340)
        ])
    }
    
    private func setupImagePageControlConstraints() {
        imagePageControl.topAnchor.constraint(equalTo: collectionView.bottomAnchor, constant: -50).isActive = true
        imagePageControl.centerXAnchor.constraint(equalTo: scrollStackViewContainer.centerXAnchor).isActive = true
    }
    
    private func setupMainStackViewConstraints() {
        NSLayoutConstraint.activate([
            mainStackView.topAnchor.constraint(equalTo: collectionView.bottomAnchor, constant: 20),
            mainStackView.leadingAnchor.constraint(equalTo: scrollStackViewContainer.leadingAnchor, constant: 16),
            mainStackView.trailingAnchor.constraint(equalTo: scrollStackViewContainer.trailingAnchor, constant: -16),
        ])
    }
    
    private func setupStarImageViewConstraints() {
        starImageView.widthAnchor.constraint(equalToConstant: 20).isActive = true
        starImageView.heightAnchor.constraint(equalToConstant: 20).isActive = true
    }
    
    private func setupLocationMapConstraints() {
        locationMapView.heightAnchor.constraint(equalToConstant: 160).isActive = true
    }
    
    private func setupAddressIconImageViewConstraints() {
        addressIconImageView.widthAnchor.constraint(equalToConstant: 20).isActive = true
        addressIconImageView.heightAnchor.constraint(equalToConstant: 20).isActive = true
    }
    
    private func setupNumberIconImageViewConstraints() {
        numberIconImageView.widthAnchor.constraint(equalToConstant: 20).isActive = true
        numberIconImageView.heightAnchor.constraint(equalToConstant: 20).isActive = true
    }
    
    private func setupCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(RestaurantImagesCollectionViewCell.self, forCellWithReuseIdentifier: "imageSlider")
    }
    
    private func setupImagePageController() {
        imagePageControl.numberOfPages = viewModel?.images?.count ?? 0
    }
    
    private func setupLabelActions() {
        let menuTapGesture = UITapGestureRecognizer(target: self, action: #selector(menuLabelDidTap))
        menuLabel.addGestureRecognizer(menuTapGesture)
        
        let websiteTapGesture = UITapGestureRecognizer(target: self, action: #selector(websiteLabelDidTap))
        websiteLabel.addGestureRecognizer(websiteTapGesture)
    }
    
    private func setupMapView() {
        let initialLocation = CLLocationCoordinate2D(
            latitude: viewModel?.latitude ?? 0.0,
            longitude: viewModel?.longitude ?? 0.0)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = initialLocation
        annotation.title = viewModel?.restaurantName
        
        locationMapView.addAnnotation(annotation)
        
        let regionRadius: CLLocationDistance = 1000
        let region = MKCoordinateRegion(center: initialLocation, latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
        locationMapView.setRegion(region, animated: true)
        
        locationMapView.register(CustomAnnotationView.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
    }
    
    private func openInMaps() {
        if let latitude = viewModel?.latitude,
           let longitude = viewModel?.longitude {
            let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
            
            let mapItem = MKMapItem(placemark: MKPlacemark(coordinate: coordinate))
            mapItem.name = viewModel?.restaurantName
            mapItem.openInMaps()
        } else {
            AlertManager.shared.showLocationUnavailableAlert(from: self)
        }
    }
    
    private func openInGoogleMaps() {
        let latitude = viewModel?.latitude
        let longitude = viewModel?.longitude
        
        let googleMapsURLString = "comgooglemaps://?center=\(String(describing: latitude)),\(String(describing: longitude))&zoom=14"
        
        if let url = URL(string: googleMapsURLString) {
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                print("Google Maps app is not installed.")
            }
        }
    }
    
    private func makePhoneCall(phoneNumber: String) {
        if let phoneCallURL = URL(string: "tel://\(phoneNumber)") {
            let application = UIApplication.shared
            if application.canOpenURL(phoneCallURL) {
                application.open(phoneCallURL, options: [:], completionHandler: nil)
            }
        }
    }
    
    // MARK: - Configure
    func configure(with restaurant: Restaurant) {
        viewModel = RestaurantDetailsViewModel(restaurant: restaurant)
        
        restaurantNameLabel.text = viewModel?.restaurantName
        restaurantCuisineLabel.text = viewModel?.cuisine
        restaurantRatingLabel.text = viewModel?.reviewStars
        restaurantOpenStatusLabel.text = viewModel?.isOpenNow ?? false ? "Open Now" : "Closed"
        restaurantOpenHoursLabel.text = viewModel?.openingHours
        restaurantDescriptionLabel.text = viewModel?.description
        restaurantAddressLabel.text = viewModel?.address
        restaurantNumberLabel.text = viewModel?.phoneNumber
    }
    
    // MARK: - Actions
    @objc private func menuLabelDidTap() {
        if let url = URL(string: viewModel?.menuURL ?? "") {
            let safariViewController = SFSafariViewController(url: url)
            present(safariViewController, animated: true, completion: nil)
        }
    }
    
    @objc private func websiteLabelDidTap() {
        if let url = URL(string: viewModel?.websiteURL ?? "") {
            let safariViewController = SFSafariViewController(url: url)
            present(safariViewController, animated: true, completion: nil)
        }
    }
    
    @objc private func openHoursDidTap() {
        let openHoursViewController = OpenHoursViewController()
        openHoursViewController.restaurant = viewModel?.restaurant
        self.navigationController?.pushViewController(openHoursViewController, animated: true)
    }
    
    @objc private func reservationButtonDidTap() {
        let reservationViewController = ReservationViewController()
        reservationViewController.selectedRestaurant = viewModel?.restaurant
        self.navigationController?.pushViewController(reservationViewController, animated: true)
    }
    
    @objc private func addressLabelDidTap() {
        let alertController = UIAlertController(title: "Address", message: nil, preferredStyle: .actionSheet)
        
        let openInMapsAction = UIAlertAction(title: "Open in Maps", style: .default) { [weak self] _ in
            self?.openInMaps()
        }
        
        let openInGoogleMapsAction = UIAlertAction(title: "Open in Google Maps", style: .default) { [weak self] _ in
            self?.openInGoogleMaps()
        }
        
        let copyAddressAction = UIAlertAction(title: "Copy Address", style: .default) { [weak self] _ in
            UIPasteboard.general.string = self?.restaurant?.location.address
            guard let strongSelf = self, let window = strongSelf.view.window else { return }
            ConfirmationBanner.show(in: window, message: "Address copied to clipboard")
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alertController.addAction(openInMapsAction)
        alertController.addAction(openInGoogleMapsAction)
        alertController.addAction(copyAddressAction)
        alertController.addAction(cancelAction)
        
        alertController.view.tintColor = .customAccentColor
        present(alertController, animated: true, completion: nil)
    }
    
    @objc private func numberLabelDidTap() {
        let phoneNumber = restaurant?.phoneNumber ?? ""
        
        let alertController = UIAlertController(title: "Phone Number", message: nil, preferredStyle: .actionSheet)
        
        let callAction = UIAlertAction(title: "Call", style: .default) { [weak self] _ in
            if !phoneNumber.isEmpty {
                self?.makePhoneCall(phoneNumber: phoneNumber)
            }
        }
        
        let copyAction = UIAlertAction(title: "Copy Number", style: .default) { [weak self] _ in
            UIPasteboard.general.string = phoneNumber
            guard let strongSelf = self, let window = strongSelf.view.window else { return }
            ConfirmationBanner.show(in: window, message: "Phone number copied to clipboard")        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alertController.addAction(callAction)
        alertController.addAction(copyAction)
        alertController.addAction(cancelAction)
        
        alertController.view.tintColor = .customAccentColor
        present(alertController, animated: true, completion: nil)
    }
}

// MARK: - UICollectionViewDataSource
extension RestaurantDetailsViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel?.images?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "imageSlider", for: indexPath) as? RestaurantImagesCollectionViewCell,
              let imageURL = viewModel?.images?[indexPath.row]
        else { return UICollectionViewCell() }
        cell.configure(with: imageURL)
        return cell
    }
}

// MARK:  UICollectionViewDelegateFlowLayout
extension RestaurantDetailsViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = Int((collectionView.frame.width))
        let height = Int((collectionView.frame.height))
        return CGSize(width: width, height: height)
    }
}

// MARK: - UIScrollViewDelegate
extension RestaurantDetailsViewController: UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageWidth = collectionView.frame.size.width
        currentCellIndex = Int(collectionView.contentOffset.x / pageWidth)
        imagePageControl.currentPage = currentCellIndex
    }
}
