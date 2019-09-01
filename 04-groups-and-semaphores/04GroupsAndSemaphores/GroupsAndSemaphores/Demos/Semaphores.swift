//
//  Semaphores.swift
//  GroupsAndSemaphores
//
//  Created by Brian Sipple on 8/30/19.
//  Copyright © 2019 CypherPoet. All rights reserved.
//

import UIKit

enum SemaphoreDemo {
    enum Error: Swift.Error {
        case noImagesDownloaded
    }
    
    private static var imageURLStrings: [String] = {
        let urlStrings = [
            "https://images.techhive.com/images/article/2017/03/mass-effect-andromeda-3-100714639-large.jpg",
            "https://pbs.twimg.com/media/C7nnzg8VMAABn3s.jpg",
            "https://steamuserimages-a.akamaihd.net/ugc/812181709679633692/0EB0E47E9C5EBB6170C52AD3A4F6847888820DAA/",
        ]
        
        return Array(repeating: urlStrings, count: 4).flatMap({ $0 })
    }()
    
    
    private static let customQueue = DispatchQueue(
        label: "Custom Queue",
        qos: .utility,
        attributes: [.concurrent]
    )
    
    
    static func runDemo(
        on queue: DispatchQueue = customQueue,
        then completionHandler: @escaping (Result<[UIImage], Error>) -> Void
    ) {
        let group = DispatchGroup()
        let semaphore = DispatchSemaphore(value: 4)
        var downloadedImages: [UIImage] = []
        
        print("Beginning \(imageURLStrings.count) downloads")
        
        for (taskNumber, urlString) in imageURLStrings.enumerated() {
            guard let url = URL(string: urlString) else { continue }
                
            // wait for an avaialbe semaphore
            semaphore.wait()
            group.enter()
            
            let task = URLSession.shared.dataTask(with: url) { (data, _, error) in
                defer {
                    semaphore.signal()
                    group.leave()
                }
                
                guard error == nil else {
                    fatalError(error!.localizedDescription)
                }
                
                print("Task \(taskNumber). Downloaded image for url: \"\(urlString)\"")
                
                guard
                    let data = data,
                    let image = UIImage(data: data)
                else { return }
                
                print("Downloaded image")
                downloadedImages.append(image)
            }
            
            task.resume()
        }
        
        
        group.notify(queue: queue) {
            if downloadedImages.isEmpty {
                completionHandler(.failure(.noImagesDownloaded))
            } else {
                completionHandler(.success(downloadedImages))
            }
        }
    }
}
