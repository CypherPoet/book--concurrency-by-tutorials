//
//  EnteringAndLeaving.swift
//  GroupsAndSemaphores
//
//  Created by Brian Sipple on 8/29/19.
//  Copyright © 2019 CypherPoet. All rights reserved.
//

import Foundation


enum EnteringAndLeaving {
    private static let customQueue = DispatchQueue(
        label: "Custom Queue",
        qos: .userInitiated,
        attributes: [.concurrent]
    )
    
    
    private static func add(
        _ firstNumber: Int,
        to secondNumber: Int,
        then completionHandler: @escaping (Int) -> Void
    ) {
        completionHandler(firstNumber + secondNumber)
    }
    
    
    static func asyncAdd(
        _ firstNumber: Int,
        to secondNumber: Int,
        using group: DispatchGroup,
        on queue: DispatchQueue = customQueue,
        then completionHandler: @escaping (Int) -> Void
    ) {
        customQueue.async(group: group) {
            group.enter()
            
            add(firstNumber, to: secondNumber) { result in
                defer { group.leave() }
                completionHandler(result)
            }
        }
    }
}
