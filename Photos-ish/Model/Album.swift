//
//  Album.swift
//  Photos-ish
//
//  Created by Juhyun Yun on 8/10/24.
//

import Foundation
import SwiftData

@Model
class Album {
    @Attribute(.unique) let id = UUID()
    let date: Date
    var name: String
    
    @Relationship var photos: [Photo]
    
    init(name: String, timestamp: Date, photos: [Photo] = []) {
        self.name = name
        self.date = timestamp
        self.photos = photos
    }
}
