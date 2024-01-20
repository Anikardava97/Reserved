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
    private let mockImages = ["Stamba1", "Stamba2", "Stamba3"]
    private var currentCellIndex = 0
    private let  imagePageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        return pageControl
    }()
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .clear
        return collectionView
    }()
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private let scrollStackViewContainer: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.spacing = 0
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
    
    private lazy var headerStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [restaurantNameAndFavoriteButtonStackView, cuisineLabel, ratingStackView])
        stackView.axis = .vertical
        stackView.spacing = 12
        stackView.distribution = .fill
        return stackView
    }()
    
    private let restaurantNameAndFavoriteButtonStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.distribution = .equalSpacing
        return stackView
    }()
    
    private let restaurantNameLabel: UILabel = {
        let label = UILabel()
        label.text = mockRestaurant.name
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        label.textColor = .white
        return label
    }()
    
    private let favoriteButton: UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = .white
        button.setImage(UIImage(systemName: "heart"), for: .normal)
        return button
    }()
    
    private let cuisineLabel: UILabel = {
        let label = UILabel()
        label.text = mockRestaurant.cuisine
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .white
        return label
    }()
    
    private lazy var ratingStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [starImageView, ratingLabel])
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
    
    private let ratingLabel: UILabel = {
        let label = UILabel()
        label.text = String(mockRestaurant.reviewStars)
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
        return stackView
    }()
    
    private lazy var openStatusStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [openStatusLabel, openHoursLabel])
        stackView.axis = .vertical
        stackView.spacing = 8
        return stackView
    }()
    
    private let openStatusLabel: UILabel = {
        let label = UILabel()
        label.text = "Open Now"
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        label.textColor = .white
        return label
    }()
    
    private let openHoursLabel: UILabel = {
        let label = UILabel()
        label.text = "12:00 PM - 12:00 AM"
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .white.withAlphaComponent(0.6)
        return label
    }()
    
    private let chevronImageView: UIButton = {
        let button = UIButton(type: .system)
        let chevronImage = UIImage(systemName: "chevron.right")
        button.setImage(chevronImage, for: .normal)
        button.tintColor = .white
        return button
    }()
    
    private let reservationButton = MainButtonComponent(
        text: "Reserve a table",
        textColor: .white,
        backgroundColor: .customAccentColor
    )
    
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
    
    private let restaurantDescriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .white
        label.numberOfLines = 3
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 6
        
        let attributedText = NSMutableAttributedString(string: mockRestaurant.description)
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
        imageView.translatesAutoresizingMaskIntoConstraints = false
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
            string: mockRestaurant.location.address,
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
        let stackView = UIStackView(arrangedSubviews: [numberTitleStackView, numberLabel])
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
        imageView.translatesAutoresizingMaskIntoConstraints = false
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
    
    private lazy var numberLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .white
        
        let underlineAttributedString = NSAttributedString(
            string: mockRestaurant.phoneNumber,
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
        setupFavoriteButtonAction()
        setupLabelActions()
        setupMapView()
    }
    
    private func setupBackground() {
        view.backgroundColor = .customBackgroundColor
    }
    
    private func setupScrollView() {
        scrollView.contentSize = CGSize(width: view.frame.width, height: view.frame.height)
        scrollView.showsVerticalScrollIndicator = false
    }
    
    private func setupSubviews() {
        view.addSubview(scrollView)
        scrollView.addSubview(scrollStackViewContainer)
        
        scrollStackViewContainer.addArrangedSubview(collectionView)
        scrollStackViewContainer.addArrangedSubview(imagePageControl)
        scrollStackViewContainer.addArrangedSubview(mainStackView)
        
        mainStackView.addArrangedSubview(headerStackView)
        restaurantNameAndFavoriteButtonStackView.addArrangedSubview(restaurantNameLabel)
        restaurantNameAndFavoriteButtonStackView.addArrangedSubview(favoriteButton)
        
        mainStackView.addArrangedSubview(urlStackView)
        mainStackView.addArrangedSubview(openStatusAndChevronStackView)
        mainStackView.addArrangedSubview(reservationButton)
        mainStackView.addArrangedSubview(aboutSectionStackView)
        mainStackView.addArrangedSubview(locationSectionStackView)
        mainStackView.addArrangedSubview(addressSectionStackView)
        mainStackView.addArrangedSubview(numberStackView)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.topAnchor.constraint(equalTo: view.topAnchor, constant: -80),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            scrollStackViewContainer.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            scrollStackViewContainer.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            scrollStackViewContainer.topAnchor.constraint(equalTo: scrollView.topAnchor),
            scrollStackViewContainer.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            scrollStackViewContainer.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            collectionView.topAnchor.constraint(equalTo: scrollStackViewContainer.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: scrollStackViewContainer.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: scrollStackViewContainer.trailingAnchor),
            collectionView.widthAnchor.constraint(equalTo: scrollStackViewContainer.widthAnchor),
            collectionView.heightAnchor.constraint(equalToConstant: 400),
            
            imagePageControl.topAnchor.constraint(equalTo: collectionView.bottomAnchor, constant: -50),
            imagePageControl.centerXAnchor.constraint(equalTo: scrollStackViewContainer.centerXAnchor),
            
            mainStackView.leadingAnchor.constraint(equalTo: scrollStackViewContainer.leadingAnchor, constant: 16),
            mainStackView.trailingAnchor.constraint(equalTo: scrollStackViewContainer.trailingAnchor, constant: -16),
            mainStackView.topAnchor.constraint(equalTo: collectionView.bottomAnchor, constant: 20),
            
            starImageView.widthAnchor.constraint(equalToConstant: 20),
            starImageView.heightAnchor.constraint(equalToConstant: 20),
            
            locationMapView.heightAnchor.constraint(equalToConstant: 160),
            
            addressIconImageView.widthAnchor.constraint(equalToConstant: 20),
            addressIconImageView.heightAnchor.constraint(equalToConstant: 20),
            
            numberIconImageView.widthAnchor.constraint(equalToConstant: 20),
            numberIconImageView.heightAnchor.constraint(equalToConstant: 20)
        ])
    }
    
    private func setupCollectionView() {
        collectionView.register(RestaurantImagesCollectionViewCell.self, forCellWithReuseIdentifier: "ImageSlider")
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.isPagingEnabled = true
    }
    
    private func setupImagePageController() {
        imagePageControl.numberOfPages = mockImages.count
    }
    
    private func setupFavoriteButtonAction() {
        favoriteButton.addAction(
            UIAction(
                title: "",
                handler: { [weak self] _ in
                    let isFavorite = self?.favoriteButton.currentImage == UIImage(systemName: "heart.fill")
                    self?.favoriteButton.setImage(UIImage(systemName: isFavorite ? "heart" : "heart.fill"), for: .normal)
                }
            ),
            for: .touchUpInside
        )
    }
    
    private func setupMapView() {
        let initialLocation = CLLocationCoordinate2D(
            latitude: mockRestaurant.location.latitude,
            longitude: mockRestaurant.location.longitude)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = initialLocation
        annotation.title = mockRestaurant.name
        
        locationMapView.addAnnotation(annotation)
        
        let regionRadius: CLLocationDistance = 1000
        let region = MKCoordinateRegion(center: initialLocation, latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
        locationMapView.setRegion(region, animated: true)
        
        locationMapView.register(CustomAnnotationView.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
    }
    
    private func setupLabelActions() {
        let menuTapGesture = UITapGestureRecognizer(target: self, action: #selector(menuLabelDidTap))
        menuLabel.addGestureRecognizer(menuTapGesture)
        
        let websiteTapGesture = UITapGestureRecognizer(target: self, action: #selector(websiteLabelDidTap))
        websiteLabel.addGestureRecognizer(websiteTapGesture)
    }
    
    private func openInMaps() {
        let latitude = mockRestaurant.location.latitude
        let longitude = mockRestaurant.location.longitude
        let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        
        let mapItem = MKMapItem(placemark: MKPlacemark(coordinate: coordinate))
        mapItem.name = mockRestaurant.name
        mapItem.openInMaps()
    }
    
    private func openInGoogleMaps() {
        let latitude = mockRestaurant.location.latitude
        let longitude = mockRestaurant.location.longitude
        
        let googleMapsURLString = "comgooglemaps://?center=\(latitude),\(longitude)&zoom=14"
        
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
    
    @objc private func addressLabelDidTap() {
        let alertController = UIAlertController(title: "Address", message: nil, preferredStyle: .actionSheet)
        
        let openInMapsAction = UIAlertAction(title: "Open in Maps", style: .default) { [weak self] _ in
            self?.openInMaps()
        }
        
        let openInGoogleMapsAction = UIAlertAction(title: "Open in Google Maps", style: .default) { [weak self] _ in
            self?.openInGoogleMaps()
        }
        
        let copyAddressAction = UIAlertAction(title: "Copy Address", style: .default) { [weak self] _ in
            UIPasteboard.general.string = mockRestaurant.location.address
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
        let phoneNumber = mockRestaurant.phoneNumber
        
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
    
    @objc private func menuLabelDidTap() {
        if let url = URL(string: mockRestaurant.menuURL) {
            let safariViewController = SFSafariViewController(url: url)
            present(safariViewController, animated: true, completion: nil)
        }
    }
    
    @objc private func websiteLabelDidTap() {
        if let url = URL(string: mockRestaurant.websiteURL) {
            let safariViewController = SFSafariViewController(url: url)
            present(safariViewController, animated: true, completion: nil)
        }
    }
}

// MARK: - CollectionView DataSource
extension RestaurantDetailsViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        mockImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageSlider", for: indexPath) as? RestaurantImagesCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        cell.restaurantImageView.image = UIImage(named: mockImages[indexPath.row])
        return cell
    }
}

// MARK: - CollectionView FlowLayoutDelegate
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

#Preview {
    RestaurantDetailsViewController()
}
