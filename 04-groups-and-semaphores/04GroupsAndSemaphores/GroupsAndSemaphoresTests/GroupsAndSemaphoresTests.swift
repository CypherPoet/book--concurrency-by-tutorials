//
//  GroupsAndSemaphoresTests.swift
//  GroupsAndSemaphores
//
//  Created by Brian Sipple on 8/29/19.
//  Copyright © 2019 CypherPoet. All rights reserved.
//

import XCTest
@testable import GroupsAndSemaphores


class GroupsAndSemaphoresTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    
    func testSynchronousWaiting() {
        let successExpectation = XCTestExpectation(description: "Should call completion handler with success result")
        let failureExpectation = XCTestExpectation(description: "Should not call completion handler with failure result")

        failureExpectation.isInverted = true
        
        SynchronousWaiting.runDemo(
            task1Duration: 0.01,
            task2Duration: 0.02,
            totalWaitDuration: 0.04
        ) { result in
            switch result {
            case .success:
                successExpectation.fulfill()
            case .failure:
                failureExpectation.fulfill()
            }
        }

        wait(for: [successExpectation, failureExpectation], timeout: 0.05)
    }
    

    func testSynchronousWaitingTimeout() {
        let successExpectation = XCTestExpectation(description: "Should not call completion handler with success result")
        let failureExpectation = XCTestExpectation(description: "Should call completion handler with failure result")

        successExpectation.isInverted = true
        
        SynchronousWaiting.runDemo(
            task1Duration: 0.04,
            task2Duration: 0.02,
            totalWaitDuration: 0.03
        ) { result in
            switch result {
            case .success:
                successExpectation.fulfill()
            case .failure:
                failureExpectation.fulfill()
            }
        }

        wait(for: [successExpectation, failureExpectation], timeout: 0.05)
    }

    
    func testGroupEntering() {
        let group = DispatchGroup()
        let expectation = XCTestExpectation(description: "Completion handler should be called")
        
        var sum = 0
        
        EnteringAndLeaving.asyncAdd(42, to: 42, using: group) { (result) in
            sum = result
            expectation.fulfill()
        }
        
        XCTAssertEqual(sum, 42 + 42)
    }
    
    
    func testImageDownloading() {
        let successExpectation = XCTestExpectation(description: "Should call completion handler with success result")
        let failureExpectation = XCTestExpectation(description: "Should not call completion handler with failure result")

        failureExpectation.isInverted = true
        
        ImageDownloading.runDemo { result in
            switch result {
            case .success:
                successExpectation.fulfill()
            case .failure:
                failureExpectation.fulfill()
            }
        }
        
        wait(for: [successExpectation, failureExpectation], timeout: 10)
    }
    
    
    func testSemaphoreDemo() {
        let successExpectation = XCTestExpectation(description: "Should call completion handler with success result")
        let failureExpectation = XCTestExpectation(description: "Should not call completion handler with failure result")

        failureExpectation.isInverted = true
        
        SemaphoreDemo.runDemo { result in
            switch result {
            case .success(let images):
                successExpectation.fulfill()
            case .failure:
                failureExpectation.fulfill()
            }
        }
        
        wait(for: [successExpectation, failureExpectation], timeout: 10)
    }
}
