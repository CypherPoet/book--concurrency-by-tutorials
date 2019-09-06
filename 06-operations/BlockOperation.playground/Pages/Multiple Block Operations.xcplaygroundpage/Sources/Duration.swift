import Foundation

public func logDuration(whileRunning block: () -> Void) -> TimeInterval {
    let startTime = Date()

    block()
    
    return Date().timeIntervalSince(startTime)
}
