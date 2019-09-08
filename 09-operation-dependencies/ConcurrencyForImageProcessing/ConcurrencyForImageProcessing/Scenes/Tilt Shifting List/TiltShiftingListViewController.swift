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
    
    private var modelController: PhotoItemModelController!
    
    private var currentDataSnapshot: DataSourceSnapshot!
    private var dataSource: DataSource!
    
    private lazy var operationQueue = OperationQueue()
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
    
    static func instantiate(modelController: PhotoItemModelController) -> TiltShiftingListViewController {
        let viewController = TiltShiftingListViewController.instantiateFromStoryboard(
            named: "TiltShiftingList"
        )
        viewController.modelController = modelController

        return viewController
    }
}


// MARK: - Lifecycle
extension TiltShiftingListViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        dataSource = makeDataSource()
        
        modelController.loadPhotoItems { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let photoItems):
                    self?.createSnapshot(withNew: photoItems)
                case .failure:
                    self?.createSnapshot(withNew: [])
                }
            }
        }
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
            
            self?.configure(cell, with: photoItem, at: indexPath)
            
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
    
    
    func configure(
        _ cell: TiltShiftedPhotoTableViewCell,
        with photoItem: PhotoItem,
        at indexPath: IndexPath
    ) {
        let loadingOperation = modelController.loadingOperation(for: photoItem)
        let tiltShiftOperation = TiltShiftingOperation()
        
        tiltShiftOperation.addDependency(loadingOperation)
        
        tiltShiftOperation.completionBlock = {
            DispatchQueue.main.async {
                guard
                    let cell = self.tableView.cellForRow(at: indexPath)
                        as? TiltShiftedPhotoTableViewCell
                else { return }

                cell.isLoading = false
                cell.shiftedImage = tiltShiftOperation.image
            }
        }
        
        cell.isLoading = true
        
        operationQueue.addOperation(loadingOperation)
        operationQueue.addOperation(tiltShiftOperation)
    }
}


extension TiltShiftingListViewController: Storyboarded {}
