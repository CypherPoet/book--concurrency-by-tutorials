//
//  TiltShiftingOperation.swift
//  ConcurrencyForImageProcessing
//
//  Created by Brian Sipple on 9/6/19.
//  Copyright © 2019 CypherPoet. All rights reserved.
//

import UIKit

final class TiltShiftingOperation: Operation {
    private let inputImage: UIImage
    
    var outputImage: UIImage?

    init(inputImage: UIImage) {
        self.inputImage = inputImage
        super.init()
    }
}


extension TiltShiftingOperation {
    
    override func main() {
        print("Beginning to filter image")

        guard
            let filteredImage = TiltShiftFilter(inputImage: inputImage, inputRadius: 3)?.outputImage
        else {
            print("Failed to generate filtered image")
            return
        }

        let ciContext = CIContext()
        let contextRect = CGRect(origin: .zero, size: inputImage.size)

        guard let cgImage = ciContext.createCGImage(filteredImage, from: contextRect) else {
            print("Failed to generate CGImage for filtered image")
            return
        }
        
        outputImage = UIImage(cgImage: cgImage)
    }
}
