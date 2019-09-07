//
//  ImageTransport.swift
//  ConcurrencyForImageProcessing
//
//  Created by Brian Sipple on 9/7/19.
//  Copyright © 2019 CypherPoet. All rights reserved.
//

import UIKit
import NetStack


final class ImageTransport: TransportRequest {
    typealias Model = Data
    
    var currentTask: URLSessionDataTask?
    let session: TransportingSession
    
    init(session: TransportingSession = URLSession.shared) {
        self.session = session
    }
}
