//
//  Collection+Ext.swift
//  Photos-ish
//
//  Created by Juhyun Yun on 8/21/24.
//

import Foundation

extension Collection {
    subscript (safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
