//
//  TiltShiftingListCoordinator.swift
//  ConcurrencyForImageProcessing
//
//  Created by Brian Sipple on 9/6/19.
//  Copyright © 2019 CypherPoet. All rights reserved.
//

import UIKit
import CypherPoetKit



final class TiltShiftingListCoordinator: NavigationCoordinator {
    var navController: UINavigationController
    let tabBarIndex: Int
    
    
    init(tabBarIndex: Int) {
        self.tabBarIndex = tabBarIndex
        self.navController = UINavigationController()
    }
    
    private static let sourceImageNames: [String] = [
        "1",
        "2",
        "3",
        "4",
        "5",
        "6",
        "7",
        "8",
        "9",
        "10",
    ]
}
 

extension TiltShiftingListCoordinator: Coordinator {

    func start() {
        let sourcePhotoItems = TiltShiftingListCoordinator.sourceImageNames.map { PhotoItem(imageName: $0) }
        
        let viewController = TiltShiftingListViewController.instantiate(
            sourcePhotoItems: sourcePhotoItems
        )
        
        viewController.tabBarItem = UITabBarItem(
            title: "List",
            image: UIImage(systemName: "square.stack.3d.down.right.fill"),
            tag: tabBarIndex
        )
        
        navController.navigationBar.isHidden = true
        navController.setViewControllers([viewController], animated: true)
    }
}


