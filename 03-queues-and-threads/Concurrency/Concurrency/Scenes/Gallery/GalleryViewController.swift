//
//  GalleryViewController.swift
//  Concurrency
//
//  Created by Brian Sipple on 8/25/19.
//  Copyright © 2019 CypherPoet. All rights reserved.
//

import UIKit
import CPStarterKitProtocols


class GalleryViewController: UIViewController {
    @IBOutlet private var collectionView: UICollectionView!
    

    var modelController: GalleryModelController!
    

    var galleryDataSource: GalleryDataSource!
}


// MARK: - Initialization
extension GalleryViewController {
    static func instantiate(
        modelController: GalleryModelController
    ) -> GalleryViewController {
        let viewController = GalleryViewController.instantiateFromStoryboard(named: "Gallery")
        
        viewController.modelController = modelController
        
        return viewController
    }
}


// MARK: - Layout Structure
extension GalleryViewController {
    enum PhotoSection: String, CaseIterable {
        case all
    }
    
    static let cellReuseID = "Gallery Photo Cell"
    
    typealias GalleryDataSource = UICollectionViewDiffableDataSource<PhotoSection, GalleryItem>
    typealias GalleryDataSourceSnapshot = NSDiffableDataSourceSnapshot<PhotoSection, GalleryItem>
}


// MARK: - Layout Composition
extension GalleryViewController {
    
    func createLayout() -> UICollectionViewLayout {
        let photoItemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(0.33),
            heightDimension: .fractionalWidth(0.33)
        )
        let photoItem = NSCollectionLayoutItem(layoutSize: photoItemSize)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(120)
        )
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [photoItem])
        
        let section = NSCollectionLayoutSection(group: group)
        
        return UICollectionViewCompositionalLayout(section: section)
    }
    
    
    func makeGalleryDataSource() -> GalleryDataSource {
        GalleryDataSource(
            collectionView: collectionView,
            cellProvider: { [weak self] (collectionView, indexPath, galleryItem) -> UICollectionViewCell? in
                guard
                    let cell = collectionView.dequeueReusableCell(
                        withReuseIdentifier: GalleryViewController.cellReuseID,
                        for: indexPath
                    ) as? GalleryCollectionViewCell
                else {
                    fatalError("Unknown cell type")
                }
         
                self?.startLoadingImage(forCellAt: indexPath, using: galleryItem)
                
                return cell
            }
        )
    }
}
    

// MARK: - Lifecycle
extension GalleryViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        galleryDataSource = makeGalleryDataSource()
        setupCollectionView()
        
        
        let snapshot = createNewSnapshot(with: modelController.photoURLs)
        galleryDataSource.apply(snapshot, animatingDifferences: true)
    }
}


// MARK: - Private Helpers
private extension GalleryViewController {

    func setupCollectionView() {
//        collectionView.register
        collectionView.collectionViewLayout = createLayout()
    }
    
    
    func createNewSnapshot(with photoURLs: [URL]) -> GalleryDataSourceSnapshot {
        var snapshot = GalleryDataSourceSnapshot()
        let galleryItems = photoURLs.map { GalleryItem(url: $0) }
        
        snapshot.appendSections([.all])
        snapshot.appendItems(galleryItems, toSection: .all)
        
        return snapshot
    }
    
    
    func startLoadingImage(forCellAt indexPath: IndexPath, using galleryItem: GalleryItem) {
        modelController.loadImage(from: galleryItem.url) { [weak self] result in
            guard let self = self else { return }
            
            if let cell = self.collectionView.cellForItem(at: indexPath) as? GalleryCollectionViewCell {
                switch result {
                case .success(let image):
                    cell.image = image
                case .failure(let error):
                    print("Error while loading image: \(error.localizedDescription)")
                }
            }
        }
    }
}


extension GalleryViewController: Storyboarded {}
