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
    
    static let samples: [Photo] = [
        .init(id: "1", url: "https://cdn2.thecatapi.com/images/110.jpg", date: Date()),
        .init(id: "2", url: "https://cdn2.thecatapi.com/images/1bs.jpg", date: Date()),
        .init(id: "3", url: "https://cdn2.thecatapi.com/images/4gq.gif", date: Date()),
        .init(id: "4", url: "https://cdn2.thecatapi.com/images/a27.jpg", date: Date()),
        .init(id: "5", url: "https://cdn2.thecatapi.com/images/a76.jpg", date: Date()),
        .init(id: "6", url: "https://cdn2.thecatapi.com/images/csk.jpg", date: Date()),
        .init(id: "7", url: "https://cdn2.thecatapi.com/images/dk3.jpg", date: Date()),
        .init(id: "8", url: "https://cdn2.thecatapi.com/images/MTgzNjE1MA.jpg", date: Date()),
        .init(id: "9", url: "https://cdn2.thecatapi.com/images/d55E_KMKZ.jpg", date: Date()),
        .init(id: "10", url: "https://cdn2.thecatapi.com/images/VsaXX13yt.jpg", date: Date())
    ]
}
