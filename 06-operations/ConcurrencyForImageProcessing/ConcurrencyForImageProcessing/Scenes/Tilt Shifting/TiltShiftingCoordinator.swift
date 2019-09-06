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
            title: "Tilt Shifting",
            image: UIImage(systemName: "square.stack.3d.down.dottedline"),
            tag: tabBarIndex
        )
        
        navController.navigationBar.isHidden = true
        navController.setViewControllers([tiltShiftingViewController], animated: true)
    }
}

