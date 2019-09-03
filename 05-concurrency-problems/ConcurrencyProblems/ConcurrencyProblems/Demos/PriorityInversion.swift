//
//  PriorityInversion.swift
//  ConcurrencyProblems
//
//  Created by Brian Sipple on 9/2/19.
//  Copyright © 2019 CypherPoet. All rights reserved.
//

import Foundation


enum PriorityInversion {

    enum Queues {
        static let highPriority = DispatchQueue(
            label: "PriorityInversion :: high-priority queue",
            qos: .userInteractive,
            attributes: [.concurrent]
        )
        
        static let mediumPriority = DispatchQueue(
            label: "PriorityInversion :: medium-priority queue",
            qos: .userInitiated,
            attributes: [.concurrent]
        )
        
        static let lowPriority = DispatchQueue(
            label: "PriorityInversion :: low-priority queue",
            qos: .background,
            attributes: [.concurrent]
        )
    }
    
    
    static func runDemo(
        using group: DispatchGroup = DispatchGroup(),
        runningFor totalDuration: TimeInterval = 5,
        then completionHandler: @escaping (Result<Void, Error>) -> Void
    ) {
        let semaphore = DispatchSemaphore(value: 1)
        let highPriorityDuration = totalDuration * 0.2
        let lowPriorityDuration = totalDuration * 0.5
        
        Queues.highPriority.async(group: group) {
            defer { semaphore.signal() }
                
            // Wait 2 seconds just to be sure all the other tasks have enqueued
            Thread.sleep(forTimeInterval: highPriorityDuration)
            
            semaphore.wait()
            
            print("High-priority queue task is now running")
        }
        
        
        for taskNumber in 1 ... 10 {
            
            // 🔑 These tasks don't require permission to acquire a resource
            // from the semaphore. So they'll each execute more or less right away, and finish before both other queues
            Queues.mediumPriority.async(group: group) {
                let waitTime = Double.random(in: totalDuration * 0.01 ... totalDuration * 0.02)
                
                print("Medium-priority queue task #\(taskNumber) is now running")
                Thread.sleep(forTimeInterval: waitTime)
            }
        }
        
        
        Queues.lowPriority.async(group: group) {
            defer { semaphore.signal() }
            
            // 🔑 Even though this is a low-priory queue, it will end up
            // beating the high-priority queue in telling the semaphore
            // that it needs a resource, and so it will execute before the
            // high-priority queue.
            semaphore.wait()
            
            print("Low-priority queue task is now running")
            Thread.sleep(forTimeInterval: lowPriorityDuration)
        }

        
        group.notify(queue: Queues.highPriority) {
            completionHandler(.success(()))
        }
    }
    
    
    
}
