//
//  TiltShiftingOperation.swift
//  ConcurrencyForImageProcessing
//
//  Created by Brian Sipple on 9/6/19.
//  Copyright © 2019 CypherPoet. All rights reserved.
//

import UIKit
import OSLog

final class TiltShiftingOperation: Operation {
    private let inputImage: UIImage?
    
    var outputImage: UIImage?

    init(inputImage: UIImage? = nil) {
        self.inputImage = inputImage
        super.init()
    }
}


// MARK: - Computeds
extension TiltShiftingOperation {
    
    var imageToFilter: UIImage? {
        if let dependencyImage = dependencies
            .compactMap({ ($0 as? ImageDataProviding)?.image })
            .first
        {
            return dependencyImage
        }
        
        return inputImage
    }
}


// MARK: - Main Task
extension TiltShiftingOperation {
    static let pointsOfInterestLog = OSLog(subsystem: "io.github.cypherpoet.ConcurrencyForImageProcessing", category: .pointsOfInterest)
    
    override func main() {
        os_signpost(.begin, log: Self.pointsOfInterestLog, name: "TiltShiftingOperation#main")
        defer { os_signpost(.end, log: Self.pointsOfInterestLog, name: "TiltShiftingOperation#main") }
        
        guard let sourceImage = imageToFilter else {
            // TODO: More robust handling here?
            print("No source image found")
            return
        }
        
        guard
            let filteredImage = TiltShiftFilter(inputImage: sourceImage, inputRadius: 3)?.outputImage
        else {
            print("Failed to generate filtered image")
            return
        }
        
        // ⚠️
        guard !isCancelled else { return }

        let ciContext = CIContext()
        let contextRect = CGRect(origin: .zero, size: sourceImage.size)

        guard let cgImage = ciContext.createCGImage(filteredImage, from: contextRect) else {
            print("Failed to generate CGImage for filtered image")
            return
        }
        
        // ⚠️
        guard !isCancelled else { return }
        
        outputImage = UIImage(cgImage: cgImage)
    }
}



// MARK: - ImageDataProviding
extension TiltShiftingOperation: ImageDataProviding {
    var image: UIImage? { outputImage }
}
