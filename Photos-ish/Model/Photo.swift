//
//  Photo.swift
//  Photos-ish
//
//  Created by Juhyun Yun on 8/10/24.
//

import Foundation
import SwiftData

@Model
class Photo {
    @Attribute(.unique) let id: String
    let url: String
    let date: Date
    var isFavorite: Bool
    
    init(id: String, url: String, date: Date, isFavorite: Bool = false) {
        self.id = id
        self.url = url
        self.date = date
        self.isFavorite = isFavorite
    }
}
