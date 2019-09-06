//: [Previous](@previous)

import Foundation


let sentence = "Keep it secret, keep it safe."
let sentenceParts = sentence.split(separator: " ")


// Even though each operation block sleeps for 2 seconds, the total time to
// run the entire operation will be just over that, since the blocks are
// executed concurrently.

let readOut = sentenceParts.reduce(BlockOperation()) { (operation, currentPart) -> BlockOperation in
    operation.addExecutionBlock {
        print(currentPart)
        sleep(2)
    }
    
    return operation
}

readOut.completionBlock = {
    print("Fin")
}


logDuration {
    readOut.start()
}

//: [Next](@next)
