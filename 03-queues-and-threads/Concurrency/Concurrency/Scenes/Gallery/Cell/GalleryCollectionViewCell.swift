//
//  GalleryCollectionViewCell.swift
//  Concurrency
//
//  Created by Brian Sipple on 8/28/19.
//  Copyright © 2019 CypherPoet. All rights reserved.
//

import UIKit

class GalleryCollectionViewCell: UICollectionViewCell {
    @IBOutlet private var imageView: UIImageView!
    
    
    var image: UIImage? {
        didSet {
            DispatchQueue.main.async {
                self.imageView.image = self.image
            }
        }
    }
}
