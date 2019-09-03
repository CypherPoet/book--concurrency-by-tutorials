//
//  ConcurrencyProblemsTests.swift
//  ConcurrencyProblemsTests
//
//  Created by Brian Sipple on 9/2/19.
//  Copyright © 2019 CypherPoet. All rights reserved.
//

import XCTest
@testable import ConcurrencyProblems

// 📝 NOTE: This might be better-demonstrated in a playground, but
// I'm currently using an Xcode beta version where playgrounds are busted 🙃

class ConcurrencyProblemsTests: XCTestCase {
    
    func testPriorityInversion() {
        let successExpectation = XCTestExpectation(description: "Should call completion handler with success result")
        let failureExpectation = XCTestExpectation(description: "Should not call completion handler with failure result")

        failureExpectation.isInverted = true
        
        PriorityInversion.runDemo() { result in
            switch result {
            case .success:
                successExpectation.fulfill()
            case .failure:
                failureExpectation.fulfill()
            }
        }

        wait(for: [successExpectation, failureExpectation], timeout: 10)
    }

}
