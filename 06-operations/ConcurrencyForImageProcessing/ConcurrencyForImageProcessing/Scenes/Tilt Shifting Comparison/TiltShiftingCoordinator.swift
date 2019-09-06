//
//  TiltShiftingCoordinator.swift
//  ConcurrencyForImageProcessing
//
//  Created by Brian Sipple on 9/5/19.
//  Copyright © 2019 CypherPoet. All rights reserved.
//


import UIKit
import CypherPoetKit


final class TiltShiftingCoordinator: NavigationCoordinator {
    var navController: UINavigationController
    let tabBarIndex: Int
    
    
    init(tabBarIndex: Int) {
        self.tabBarIndex = tabBarIndex
        self.navController = UINavigationController()
    }
}
 

extension TiltShiftingCoordinator: Coordinator {

    func start() {
        let tiltShiftingViewController = TiltShiftingViewController.instantiate(
            sourceImage: UIImage(named: "dark_road_small")
        )
        
        tiltShiftingViewController.tabBarItem = UITabBarItem(
            title: "Comparison",
            image: UIImage(systemName: "square.split.1x2"),
            tag: tabBarIndex
        )
        
        navController.navigationBar.isHidden = true
        navController.setViewControllers([tiltShiftingViewController], animated: true)
    }
}

