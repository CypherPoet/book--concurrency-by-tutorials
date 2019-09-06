//
//  TiltShiftingListViewController.swift
//  ConcurrencyForImageProcessing
//
//  Created by Brian Sipple on 9/6/19.
//  Copyright © 2019 CypherPoet. All rights reserved.
//

import UIKit
import CoreGraphics
import CypherPoetKit


class TiltShiftingListViewController: UIViewController {
    @IBOutlet private var tableView: UITableView!
    
    private var sourcePhotoItems: [PhotoItem]!
    
    private var currentDataSnapshot: DataSourceSnapshot!
    private var dataSource: DataSource!
    
}

struct PhotoItem: Identifiable, Hashable {
    let id: UUID = UUID()
    var imageName: String
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(imageName)
    }
}

// MARK: - Table View Structure
extension TiltShiftingListViewController {
    enum TableSection: CaseIterable {
        case all
    }
    
    typealias DataSource = UITableViewDiffableDataSource<TableSection, PhotoItem>
    typealias DataSourceSnapshot = NSDiffableDataSourceSnapshot<TableSection, PhotoItem>
}


// MARK: - Instantiation
extension TiltShiftingListViewController {
    
    static func instantiate(sourcePhotoItems: [PhotoItem]) -> TiltShiftingListViewController {
        let viewController = TiltShiftingListViewController.instantiateFromStoryboard(
            named: "TiltShiftingList"
        )
        viewController.sourcePhotoItems = sourcePhotoItems

        return viewController
    }
}


// MARK: - Lifecycle
extension TiltShiftingListViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        dataSource = makeDataSource()
        createSnapshot(withNew: sourcePhotoItems)
    }
}


private extension TiltShiftingListViewController {
    
    func setupTableView() {
        tableView.register(
            TiltShiftedPhotoTableViewCell.nib,
            forCellReuseIdentifier: TiltShiftedPhotoTableViewCell.reuseIdentifier
        )
    }
    
    func makeDataSource() -> DataSource {
        DataSource(tableView: tableView) {
            [weak self] (tableView, indexPath, photoItem) -> UITableViewCell? in
            
            guard
                let cell = tableView.dequeueReusableCell(
                    withIdentifier: TiltShiftedPhotoTableViewCell.reuseIdentifier,
                    for: indexPath
                ) as? TiltShiftedPhotoTableViewCell
            else { fatalError() }
            
//            let tiltShiftingTask =
            self?.configure(cell, with: photoItem)
            
            return cell
        }
    }
    
    
    func createSnapshot(withNew photoItems: [PhotoItem], animate: Bool = true) {
        guard let dataSource = dataSource else { return }
        
        var snapshot = dataSource.snapshot()
        
        snapshot.appendSections([.all])
        snapshot.appendItems(photoItems, toSection: .all)
        
        dataSource.apply(snapshot, animatingDifferences: animate)
    }
    
    
    func configure(_ cell: TiltShiftedPhotoTableViewCell, with photoItem: PhotoItem) {
        guard let sourceImage = UIImage(named: photoItem.imageName) else { return }
        
        print("Beginning to filter image named \"\(photoItem.imageName)\"")
        
        guard
            let filteredImage = TiltShiftFilter(inputImage: sourceImage, inputRadius: 3)?.outputImage
        else {
            print("Failed to generate filtered image for image named \"\(photoItem.imageName)\"")
            return
        }
        
        let ciContext = CIContext()
        let contextRect = CGRect(origin: .zero, size: sourceImage.size)
        
        guard let cgImage = ciContext.createCGImage(filteredImage, from: contextRect) else {
            print("Failed to generate CGImage for image named \"\(photoItem.imageName)\"")
            return
        }
        
        cell.shiftedImage = UIImage(cgImage: cgImage)
    }
}


extension TiltShiftingListViewController: Storyboarded { }
