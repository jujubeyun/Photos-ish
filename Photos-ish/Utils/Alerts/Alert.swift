//
//  Alert.swift
//  Photos-ish
//
//  Created by Juhyun Yun on 8/12/24.
//

import Foundation

enum AlertType {
    case add, delete(album: Album)
    
    var title: String {
        switch self {
        case .add:
            "New Album"
        case .delete(let album):
            "Delete \"\(album.name)\""
        }
    }
    
    var message: String {
        switch self {
        case .add:
            "Enter a name for this album."
        case .delete(let album):
            "Are you sure you want to delete the album \"\(album.name)\"? The Photos will not be deleted."
        }
    }
}
