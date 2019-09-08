//
//  ImageTransportOperation.swift
//  ConcurrencyForImageProcessing
//
//  Created by Brian Sipple on 9/7/19.
//  Copyright © 2019 CypherPoet. All rights reserved.
//

import UIKit


final class ImageTransportOperation: AsyncOperation {
    typealias RequestCompletionHandler = ((Result<Data, Error>) -> Void)
    
    private let imageLoader: ImageTransport
    private let imageURL: URL
    
    /// Provide this if you'd like to handle the result of performing the load
    /// request directly
    private let requestCompletionHandler: RequestCompletionHandler?

    /// If no `requestCompletionHandler` is provided, the `main` function of the operation
    /// will attempt to set this and make it available for future access.
    var loadedImage: UIImage?
    
    
    init(
        imageURL: URL,
        imageLoader: ImageTransport = .init(),
        completionHandler: RequestCompletionHandler? = nil
    ) {
        self.imageURL = imageURL
        self.imageLoader = imageLoader
        self.requestCompletionHandler = completionHandler
        
        super.init()
    }
}


// MARK: - Cancellation
extension ImageTransportOperation {
    override func cancel() {
        super.cancel()
        imageLoader.cancelCurrentTask()
    }
}



// MARK: - Main Task
extension ImageTransportOperation {
    
    override func main() {
        let urlRequest = URLRequest(url: imageURL)
        
        imageLoader.perform(urlRequest) { [weak self] dataResult in
            guard let self = self else { return }
            
            defer { self.state = .finished }
            
            if let completionHandler = self.requestCompletionHandler {
                completionHandler(dataResult)
                return
            } else {
                switch dataResult {
                case .success(let data):
                    self.loadedImage = UIImage(data: data)
                case .failure:
                    break
                }
            }
        }
    }
}


// MARK: - ImageDataProviding
extension ImageTransportOperation: ImageDataProviding {
    var image: UIImage? { loadedImage }
}
