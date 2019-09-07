//
//  AppCoordinator.swift
//  ConcurrencyForImageProcessing
//
//  Created by Brian Sipple on 9/5/19.
//  Copyright © 2019 CypherPoet. All rights reserved.
//

import UIKit
import CypherPoetKit


final class AppCoordinator: NavigationCoordinator {
    private let window: UIWindow
    var navController: UINavigationController

    
    init(navController: UINavigationController, window: UIWindow) {
        self.navController = navController
        self.window = window
    }
}


// MARK: - Coordinator
extension AppCoordinator: Coordinator {
    
    func start() {
        window.rootViewController = rootViewController
        window.makeKeyAndVisible()
        
        let mainViewCoordinator = MainViewCoordinator(navController: navController)
        
        mainViewCoordinator.start()
    }
}
