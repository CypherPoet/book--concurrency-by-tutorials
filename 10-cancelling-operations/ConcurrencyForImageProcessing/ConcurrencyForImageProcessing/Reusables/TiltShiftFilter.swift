//
//  TiltShiftFilter.swift
//  ConcurrencyForImageProcessing
//
//  Created by Brian Sipple on 9/5/19.
//  Copyright © 2019 CypherPoet. All rights reserved.
//

import UIKit
import CoreGraphics


final class TiltShiftFilter: CIFilter {
    private static let defaultRadius = 10.0
    
    private var inputImage: CIImage?
    private var inputRadius: Double = 0.0
    
    
    convenience init?(inputImage: UIImage, inputRadius: Double = TiltShiftFilter.defaultRadius) {
        guard let backing = inputImage.ciImage ?? CIImage(image: inputImage) else { return nil }
        
        self.init()

        self.inputRadius = inputRadius
        self.inputImage = backing
    }
}


extension TiltShiftFilter {
    var gradientImage: CIImage? {
        guard let inputImage = inputImage else { return nil }
        
        return ciImage(from: "CILinearGradient", parameters: gradientParameters(for: inputImage))
    }
    
    
    var backgroundGradientImage: CIImage? {
        guard let inputImage = inputImage else { return nil }
        
        return ciImage(from: "CILinearGradient", parameters: backgroundGradientParameters(for: inputImage))
    }
    
    var maskImage: CIImage? {
        guard
            let gradientImage = gradientImage,
            let backgroundGradientImage = backgroundGradientImage
        else { return nil }
        
        let maskParameters = [
          kCIInputImageKey: gradientImage,
          kCIInputBackgroundImageKey: backgroundGradientImage
        ]
        
        return ciImage(from: "CIAdditionCompositing", parameters: maskParameters)
    }
}


extension TiltShiftFilter {
    override var inputKeys: [String] { [kCIInputImageKey, kCIInputRadiusKey] }
    
    override var name: String {
        get { "Tilt Shift Filter" }
        set { }
    }

    override func setDefaults() {
        super.setDefaults()
        inputRadius = TiltShiftFilter.defaultRadius
    }
    

    override var outputImage: CIImage? {
        guard
            let inputImage = inputImage,
            let maskImage = maskImage
        else { return nil }
        
        // Create a blurred version of the image.
        let clampedInputImage = inputImage.clampedToExtent()
        let blurredImage = clampedInputImage.applyingGaussianBlur(sigma: inputRadius)
        
        // Composite the blurred image, the mask, and the original image.
        let compositeImageParameters = [
            kCIInputImageKey: blurredImage,
            kCIInputMaskImageKey: maskImage,
            kCIInputBackgroundImageKey: clampedInputImage,
        ]
        
        return ciImage(from: "CIBlendWithMask", parameters: compositeImageParameters)
    }
}


private extension TiltShiftFilter {
    
    func ciImage(from filterName: String, parameters: [String: Any]) -> CIImage? {
        guard let filter = CIFilter(name: filterName, parameters: parameters) else { return nil }
        
        return filter.outputImage
    }

    
    func gradientParameters(for inputImage: CIImage) -> [String: Any] {
        [
            "inputPoint0": CIVector(x: 0, y: inputImage.extent.height * 0.75),
            "inputColor0": CIColor(red: 0, green: 1, blue: 0, alpha: 1),
            "inputPoint1": CIVector(x: 0, y: inputImage.extent.height * 0.5),
            "inputColor1": CIColor(red: 0, green: 1, blue: 0, alpha: 0)
        ]
    }

    func backgroundGradientParameters(for inputImage: CIImage) -> [String: Any] {
        var params = gradientParameters(for: inputImage)
        params["inputPoint0"] = CIVector(x: 0, y: inputImage.extent.height * 0.25)
        
        return params
    }
}
