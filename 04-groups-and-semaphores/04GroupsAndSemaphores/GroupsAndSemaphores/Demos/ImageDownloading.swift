//
//  ImageDownloading.swift
//  GroupsAndSemaphores
//
//  Created by Brian Sipple on 8/30/19.
//  Copyright © 2019 CypherPoet. All rights reserved.
//

import UIKit


enum ImageDownloading {

    enum Error: Swift.Error {
        case noImageLoaded
    }
    
    private static let imageURLStrings = [
        "https://images.techhive.com/images/article/2017/03/mass-effect-andromeda-3-100714639-large.jpg",
        "http://news.tagmyride.mobi/wp-content/uploads/2017/01/3179981-mea.jpg",
        "https://pbs.twimg.com/media/C7nnzg8VMAABn3s.jpg",
        "https://steamuserimages-a.akamaihd.net/ugc/812181709679633692/0EB0E47E9C5EBB6170C52AD3A4F6847888820DAA/",
    ]
    
    private static let customQueue = DispatchQueue(
        label: "Custom Queue",
        qos: .utility,
        attributes: [.concurrent]
    )


    // Challenge: Download each image from the provided names array in
    // an asynchronous manner.
    // When complete, you should show at least one of the images and terminate the playground.
    static func runDemo(
        on queue: DispatchQueue = customQueue,
        then completionHandler: @escaping (Result<UIImage, Error>) -> Void
    ) {
        let group = DispatchGroup()
        var loadedImages: [UIImage] = []
        
        for urlString in imageURLStrings {
            guard let url = URL(string: urlString) else { continue }
            
            group.enter()
            
            URLSession.shared.dataTask(with: url) { (data, _, error) in
                defer { group.leave() }
                
                guard
                    let data = data,
                    let image = UIImage(data: data)
                else { return }

                loadedImages.append(image)
            }.resume()
        }
        
        
        group.notify(queue: queue) {
            if let firstLoadedImage = loadedImages.first {
                completionHandler(.success(firstLoadedImage))
            } else {
                completionHandler(.failure(.noImageLoaded))
            }
        }
    }
}
