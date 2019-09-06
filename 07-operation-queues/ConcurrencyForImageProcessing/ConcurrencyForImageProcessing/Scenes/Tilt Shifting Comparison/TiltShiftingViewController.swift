//
//  TiltShiftingViewController.swift
//  ConcurrencyForImageProcessing
//
//  Created by Brian Sipple on 9/5/19.
//  Copyright © 2019 CypherPoet. All rights reserved.
//

import UIKit
import CypherPoetKit


class TiltShiftingViewController: UIViewController {
    @IBOutlet private var sourceImageView: UIImageView!
    @IBOutlet private var filteredImageView: UIImageView!
    
    private enum ImageFilteringState {
        case notStarted
        case inProgress
        case done(making: CGImage)
        case failed(_ errorMessage: String)
    }

    private var currentImageFilteringState: ImageFilteringState = .notStarted {
        didSet {
            DispatchQueue.main.async {
                self.imageFilteringStateChanged()
            }
        }
    }
    
    private lazy var loadingViewController = LoadingViewController()
    private var imageToFilter: UIImage!
}


// MARK: - Instantiation
extension TiltShiftingViewController {
    
    static func instantiate(sourceImage: UIImage?) -> TiltShiftingViewController {
        guard let imageToFilter = sourceImage else { preconditionFailure() }
        
        let viewController = TiltShiftingViewController.instantiateFromStoryboard(
            named: "TiltShifting"
        )
        viewController.imageToFilter = imageToFilter

        return viewController
    }
}


// MARK: - Lifecycle
extension TiltShiftingViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sourceImageView.image = imageToFilter
        applyFiltering(to: imageToFilter)
    }
}


private extension TiltShiftingViewController {
    
    func applyFiltering(to image: UIImage) {
        currentImageFilteringState = .inProgress
        
        guard
            let tiltShiftFilter = TiltShiftFilter(inputImage: image, inputRadius: 4.3),
            let filteredImage = tiltShiftFilter.outputImage
        else {
            currentImageFilteringState = .failed("Failed to generate filtered image")
            return
        }

        let context = CIContext()
        
        guard let cgImage = context.createCGImage(
            filteredImage,
            from: CGRect(origin: .zero, size: image.size)
        ) else {
            currentImageFilteringState = .failed("Failed to generate CGImage from filtered image")
            return
        }
        
        self.currentImageFilteringState = .done(making: cgImage)
    }
    
    
    func imageFilteringStateChanged() {
        switch currentImageFilteringState {
        case .notStarted: break
        case .inProgress:
            add(child: loadingViewController)
        case .done(let cgImage):
            loadingViewController.performRemoval()
            filteredImageView.image = UIImage(cgImage: cgImage)
        case .failed(let errorMessage):
            loadingViewController.performRemoval()
            display(alertMessage: errorMessage, titled: "Filtering Error")
        }
    }
}


extension TiltShiftingViewController: Storyboarded {}
