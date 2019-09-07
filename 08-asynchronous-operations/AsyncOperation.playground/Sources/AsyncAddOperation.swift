import Foundation


/**
    AsyncAddOperation simply adds two numbers together asynchronously and
    assigns the result.
 
    It sleeps for two seconds just so that you can see the random ordering of the operation.

    Nothing guarantees that an operation will complete in the order it was added.

    - Important:
    Notice that `self.state` is being set to `.finished`. What would happen if you left this line out?
 */
public class AsyncAddOperation: AsyncOperation {
    private let lhs: Int
    private let rhs: Int
    
    public var result: Int?
    
    public init(lhs: Int, rhs: Int) {
        self.lhs = lhs
        self.rhs = rhs
        
        super.init()
    }
}


extension AsyncAddOperation {
    
    public override func main() {
        DispatchQueue.global().async {
            Thread.sleep(forTimeInterval: 2)
            
            self.result = self.lhs + self.rhs
            
            // 🔑 Set this, or the operation will never complete!
            self.state = .finished
        }
    }
}


extension AsyncAddOperation {
    
}


