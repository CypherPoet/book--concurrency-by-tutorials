//: [Previous](@previous)

import UIKit


let pairs = [(1, 1), (23, 63), (345, 3), (58, 24), (94, 43), (3, 7)]
let queue = OperationQueue()

for (lhs, rhs) in pairs {
    let operation = AsyncAddOperation(lhs: lhs, rhs: rhs)
    
    operation.completionBlock = {
        guard let sum = operation.result else { return }
        print("\(lhs) + \(rhs) = \(sum)")
    }
    
    queue.addOperation(operation)
}

//: This prevents the playground from finishing prematurely.  Never do this on a main UI thread!
queue.waitUntilAllOperationsAreFinished()

//: [Next](@next)
