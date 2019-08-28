//
//  GalleryModelController.swift
//  Concurrency
//
//  Created by Brian Sipple on 8/27/19.
//  Copyright © 2019 CypherPoet. All rights reserved.
//

import UIKit


final class GalleryModelController {
    private let imageLoader: ImageTransport

    enum Error: Swift.Error {
        case invalidImageData
    }
    
    
    init(imageLoader: ImageTransport = ImageTransport()) {
        self.imageLoader = imageLoader
    }
    
    
    lazy var photoURLs: [URL] = {
        guard
            let plistURL = Bundle.main.url(forResource: "Photos", withExtension: "plist"),
            let plistData = try? Data(contentsOf: plistURL),
            let serializedValues = try? PropertyListSerialization.propertyList(from: plistData, format: nil),
            let photoURLStrings = serializedValues as? [String]
        else {
            fatalError("Error while getting image URLS from plist")
        }
        
        return photoURLStrings.compactMap { URL(string: $0) }
    }()
    
    
    func loadImage(
        from url: URL,
        then completionHandler: @escaping (Result<UIImage, Error>) -> Void
    )  {
        let urlRequest = URLRequest(url: url)
        
        DispatchQueue.global(qos: .utility).async { [weak self] in
            self?.imageLoader.perform(urlRequest) { result in
                switch result {
                case .success(let data):
                    guard let image = UIImage(data: data) else {
                        completionHandler(.failure(.invalidImageData))
                        return
                    }
                    
                    completionHandler(.success(image))
                case .failure(let error):
                    fatalError(error.localizedDescription)
                }
            }
        }
    }
}
