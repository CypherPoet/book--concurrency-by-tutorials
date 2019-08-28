//
//  AppCoordinator.swift
//  Concurrency
//
//  Created by Brian Sipple on 8/26/19.
//  Copyright © 2019 CypherPoet. All rights reserved.
//

import UIKit
import CPStarterKitProtocols


final class AppCoordinator: NavigationCoordinator {
    let window: UIWindow
    var navController: UINavigationController
    
    
    init(
        window: UIWindow,
        navController: UINavigationController
    ) {
        self.window = window
        self.navController = navController
    }
}


// MARK: - Coordinator
extension AppCoordinator: Coordinator {
    func start() {
        window.rootViewController = rootViewController
        window.makeKeyAndVisible()
        
        showGallery()
    }
}


// MARK: - Navigation
extension AppCoordinator {

    func showGallery() {
        let galleryCoordinator = GalleryCoordinator(
            navController: navController,
            modelController: GalleryModelController()
        )
        
        galleryCoordinator.start()
    }
}
