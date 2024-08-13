//
//  Photo.swift
//  Photos-ish
//
//  Created by Juhyun Yun on 8/10/24.
//

import Foundation
import SwiftData

@Model
class Photo: Hashable {
    @Attribute(.unique) let id = UUID()
    let url: String
    let date: Date
    var isFavorite: Bool
    var album: Album?
    
    init(url: String, date: Date, isFavorite: Bool = false, album: Album? = nil) {
        self.url = url
        self.date = date
        self.isFavorite = isFavorite
        self.album = album
    }
}
