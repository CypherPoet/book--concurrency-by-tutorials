//
//  GalleryCoordinator.swift
//  Concurrency
//
//  Created by Brian Sipple on 8/27/19.
//  Copyright © 2019 CypherPoet. All rights reserved.
//

import UIKit
import CPStarterKitProtocols


final class GalleryCoordinator: NavigationCoordinator {
    var navController: UINavigationController
    let modelController: GalleryModelController
    

    init(
        navController: UINavigationController,
        modelController: GalleryModelController
    ) {
        self.navController = navController
        self.modelController = modelController
    }
}




// MARK: - Coordinator
extension GalleryCoordinator: Coordinator {
    
    func start() {
        let galleryViewController = GalleryViewController.instantiate(
            modelController: modelController
        )
        
        navController.setViewControllers([galleryViewController], animated: true)
    }
}
