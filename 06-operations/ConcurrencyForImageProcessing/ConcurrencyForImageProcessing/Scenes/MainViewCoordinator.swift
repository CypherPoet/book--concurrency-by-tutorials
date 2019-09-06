//
//  MainViewCoordinator.swift
//  ConcurrencyForImageProcessing
//
//  Created by Brian Sipple on 9/5/19.
//  Copyright © 2019 CypherPoet. All rights reserved.
//

import UIKit
import CypherPoetKit


final class MainViewCoordinator {
    let navController: UINavigationController
    private let tabBarController: UITabBarController

    
    init(navController: UINavigationController) {
        self.navController = navController
        self.tabBarController = UITabBarController()
    }
}
 

extension MainViewCoordinator: Coordinator {
    var rootViewController: UIViewController { navController }
    
    
    func start() {
        let tiltShiftingCoordinator = TiltShiftingCoordinator(tabBarIndex: 0)
        tiltShiftingCoordinator.start()
        
        
        tabBarController.setViewControllers([
            tiltShiftingCoordinator.rootViewController
        ], animated: true)
        
        navController.setViewControllers([tabBarController], animated: true)
    }
}

