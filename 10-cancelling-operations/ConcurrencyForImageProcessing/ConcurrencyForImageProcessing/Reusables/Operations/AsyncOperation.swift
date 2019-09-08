//
//  AsyncOperation.swift
//  ConcurrencyForImageProcessing
//
//  Created by Brian Sipple on 9/7/19.
//  Copyright © 2019 CypherPoet. All rights reserved.
//

import Foundation


public class AsyncOperation: Operation {
    
    /// Allows us to asynchrounously track changes of the operation state
    public enum State: String {
        case ready
        case executing
        case finished
        
        /// This allows the enum to correspond to the `is-*` properties of the `Operation` class.
        /// and signal to them through KVO.
        fileprivate var operationKeyPath: String {
            return "is\(rawValue.capitalized)"
        }
    }
    
    public var state: State = .ready {
        willSet {
            willChangeValue(forKey: newValue.operationKeyPath)
            willChangeValue(forKey: state.operationKeyPath)
        }
        didSet {
            didChangeValue(forKey: oldValue.operationKeyPath)
            didChangeValue(forKey: state.operationKeyPath)
        }
    }
}


// MARK: - Computeds
extension AsyncOperation {
    
    public override var isAsynchronous: Bool { true }
    
    // 📝 NOTE: It’s critical to check the base class's `isReady` method.
    // Our code isn’t aware of everything that goes on while the scheduler determines whether
    // or not it is ready to find a thread for the operation.
    public override var isReady: Bool { super.isReady && state == .ready }
    
    public override var isExecuting: Bool { state == .executing }
    public override var isFinished: Bool { state == .finished }
}


// MARK: - Core Functions

extension AsyncOperation {
    
    public override func start() {
        
        // Support operation cancellablity 
        guard !isCancelled else {
            state = .finished
            return
        }
        
        main()
        state = .executing
    }
}
