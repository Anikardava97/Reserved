//
//  RestaurantDetailsViewController.swift
//  Reserved
//
//  Created by Ani's Mac on 20.01.24.
//

import UIKit

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
        setupImagePageController()
    }
    
    private func setupBackground() {
        view.backgroundColor = .customBackgroundColor
    }
    private func setupSubviews() {
        view.addSubview(collectionView)
        view.addSubview(imagePageControl)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.widthAnchor.constraint(equalTo: view.widthAnchor),
            collectionView.heightAnchor.constraint(equalToConstant: 400),
            
            imagePageControl.topAnchor.constraint(equalTo: collectionView.bottomAnchor, constant: 12),
            imagePageControl.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imagePageControl.heightAnchor.constraint(equalToConstant: 20)
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
