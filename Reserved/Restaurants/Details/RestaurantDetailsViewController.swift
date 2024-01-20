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
        stackView.spacing = 20
        stackView.translatesAutoresizingMaskIntoConstraints = false
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
    
    private let restaurantAddressLabel: UILabel = {
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
        
        mainStackView.addArrangedSubview(restaurantNameAndFavoriteButtonStackView)
        restaurantNameAndFavoriteButtonStackView.addArrangedSubview(restaurantNameLabel)
        restaurantNameAndFavoriteButtonStackView.addArrangedSubview(favoriteButton)
        
        mainStackView.addArrangedSubview(cuisineLabel)
        mainStackView.addArrangedSubview(ratingStackView)
        mainStackView.addArrangedSubview(urlStackView)
        mainStackView.addArrangedSubview(aboutSectionStackView)
        mainStackView.addArrangedSubview(locationSectionStackView)
        mainStackView.addArrangedSubview(addressSectionStackView)
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
            
            addressIconImageView.widthAnchor.constraint(equalToConstant: 20),
            addressIconImageView.heightAnchor.constraint(equalToConstant: 20),
            
            locationMapView.heightAnchor.constraint(equalToConstant: 160),
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
