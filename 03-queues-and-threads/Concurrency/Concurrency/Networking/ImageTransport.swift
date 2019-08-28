//
//  ImageTransport.swift
//  Concurrency
//
//  Created by Brian Sipple on 8/26/19.
//  Copyright © 2019 CypherPoet. All rights reserved.
//

import UIKit
import NetStack


final class ImageTransport: TransportRequest {
    typealias Model = Data
    
    var session: TransportingSession
    var currentTask: URLSessionDataTask?
    
    init(session: TransportingSession = URLSession.shared) {
        self.session = session
    }
}
