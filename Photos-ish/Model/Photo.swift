//
//  Photo.swift
//  Photos-ish
//
//  Created by Juhyun Yun on 8/10/24.
//

import SwiftData

@Model
class Photo {
    @Attribute(.unique) let id: String
    let url: String
    var isFavorite: Bool
    
    init(id: String, url: String, isFavorite: Bool = false) {
        self.id = id
        self.url = url
        self.isFavorite = isFavorite
    }
}
