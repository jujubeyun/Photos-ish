//
//  CatImage.swift
//  Photos-ish
//
//  Created by Juhyun Yun on 8/9/24.
//

import Foundation

struct CatImage: Decodable, Hashable, Identifiable {
    let id: String
    let url: String
}
