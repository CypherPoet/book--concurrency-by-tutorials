//
//  PhotoItem.swift
//  ConcurrencyForImageProcessing
//
//  Created by Brian Sipple on 9/6/19.
//  Copyright © 2019 CypherPoet. All rights reserved.
//

import Foundation


struct PhotoItem: Identifiable, Hashable {
    let id: UUID = UUID()
    var imageName: String
    var imageURL: URL?
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(imageName)
    }
}
