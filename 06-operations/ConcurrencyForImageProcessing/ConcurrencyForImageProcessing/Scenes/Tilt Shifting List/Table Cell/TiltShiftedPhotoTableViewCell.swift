//
//  TiltShiftedPhotoTableViewCell.swift
//  ConcurrencyForImageProcessing
//
//  Created by Brian Sipple on 9/6/19.
//  Copyright © 2019 CypherPoet. All rights reserved.
//

import UIKit


class TiltShiftedPhotoTableViewCell: UITableViewCell {
    @IBOutlet private var shiftedImageView: UIImageView!
    
    var shiftedImage: UIImage? {
        didSet {
            DispatchQueue.main.async {
                self.shiftedImageView.image = self.shiftedImage
            }
        }
    }
}


extension TiltShiftedPhotoTableViewCell {
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}


extension TiltShiftedPhotoTableViewCell {
    static let reuseIdentifier = "Tilt Shifted Photo Table Cell"
    
    static var nib: UINib {
        UINib(nibName: "TiltShiftedPhotoTableViewCell", bundle: nil)
    }
}
