//
//  PhotoItemModelController.swift
//  ConcurrencyForImageProcessing
//
//  Created by Brian Sipple on 9/7/19.
//  Copyright © 2019 CypherPoet. All rights reserved.
//

import UIKit


final class PhotoItemModelController {
    private let imageLoader: ImageTransport
    private lazy var photoURLs: [URL] = makePhotoURLS()

    enum Error: Swift.Error {
        case invalidImageData
    }

    var photoItems: [PhotoItem] = []
    
    init(imageLoader: ImageTransport = ImageTransport()) {
        self.imageLoader = imageLoader
    }
}


extension PhotoItemModelController {
    
    func loadingOperation(for photoItem: PhotoItem) -> ImageTransportOperation {
        ImageTransportOperation(imageURL: photoItem.imageURL)
    }
    
    
    func loadPhotoItems(then completionHandler: ((Result<[PhotoItem], Error>) -> Void)?) {
        photoItems = photoURLs.map { PhotoItem(imageURL: $0) }
        
        // 🔑 An modification here could be to have this called without a completion handler,
        // and instead allow for notifiable observers to be set on `photoItems`
        completionHandler?(.success(photoItems))
    }
}


private extension PhotoItemModelController {
    
    func makePhotoURLS() -> [URL] {
        guard
            let plistURL = Bundle.main.url(forResource: "Photos", withExtension: "plist"),
            let plistData = try? Data(contentsOf: plistURL),
            let serializedValues = try? PropertyListSerialization.propertyList(from: plistData, format: nil),
            let photoURLStrings = serializedValues as? [String]
        else {
            fatalError("Error while getting image URLS from plist")
        }
        
        return photoURLStrings.compactMap { URL(string: $0) }
    }
}
