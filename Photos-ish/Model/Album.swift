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
    let name: String
    let date: Date
    let isEditable: Bool
    
    @Relationship(deleteRule: .nullify, inverse: \Photo.albums)
    var photos: [Photo]
    
    init(name: String, date: Date, isEditable: Bool = true, photos: [Photo] = []) {
        self.name = name
        self.date = date
        self.isEditable = isEditable
        self.photos = photos
    }
    
    var sortedPhotos: [Photo] {
        self.photos.sorted { $0.date < $1.date }
    }
}
