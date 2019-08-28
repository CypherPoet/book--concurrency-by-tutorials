//
//  GalleryItem.swift
//  Concurrency
//
//  Created by Brian Sipple on 8/28/19.
//  Copyright © 2019 CypherPoet. All rights reserved.
//

import Foundation

struct GalleryItem {
    private let id: UUID = .init()
    var url: URL
}


extension GalleryItem: Hashable {
    func combine(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
