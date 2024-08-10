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
    var name: String
    
    @Relationship var photos: [Photo]?
    
    init(name: String, photos: [Photo]? = nil) {
        self.name = name
        self.photos = photos
    }
}
