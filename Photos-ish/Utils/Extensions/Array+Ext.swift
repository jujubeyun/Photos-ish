//
//  Array+Ext.swift
//  Photos-ish
//
//  Created by Juhyun Yun on 8/14/24.
//

import Foundation

extension Array {
    subscript(safe index: Int?) -> Element? {
        guard let index else { return nil }
        return indices ~= index ? self[index] : nil
    }
}
