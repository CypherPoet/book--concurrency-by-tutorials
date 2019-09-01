//
//  SynchronousWaiting.swift
//  GroupsAndSemaphores
//
//  Created by Brian Sipple on 8/29/19.
//  Copyright © 2019 CypherPoet. All rights reserved.
//

import Foundation

enum SynchronousWaiting {
    static let customQueue1 = DispatchQueue(
        label: "Custom Queue 1",
        qos: .userInitiated,
        attributes: [.concurrent]
    )
    
    static let globalQueue = DispatchQueue.global(qos: .userInitiated)
    
    
    enum Error: Swift.Error {
        case timedOut
    }
    
    
    static func runDemo(
        task1Duration: TimeInterval = 10,
        task2Duration: TimeInterval = 2,
        totalWaitDuration: TimeInterval = 10,
        then completionHandler: @escaping (Result<Void, Error>) -> Void
    ) {
        let group = DispatchGroup()
        
        customQueue1.async(group: group) {
            print("Starting task 1...")
            Thread.sleep(until: Date().addingTimeInterval(task1Duration))
            print("Ending task 1...")
        }
        
        customQueue1.async(group: group) {
            print("Starting task 2...")
            Thread.sleep(until: Date().addingTimeInterval(task2Duration))
            print("Ending task 2...")
        }
        
        if group.wait(timeout: .now() + totalWaitDuration) == .timedOut {
            print("Timed out after waiting")
            completionHandler(.failure(.timedOut))
        } else {
            print("All tasks are complete")
            completionHandler(.success(()))
        }
    }
}
