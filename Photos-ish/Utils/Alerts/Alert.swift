//
//  Alert.swift
//  Photos-ish
//
//  Created by Juhyun Yun on 8/12/24.
//

import Foundation

enum AlertType {
    case add
    case delete(album: Album)
    case invalidURL
    case invalidResponse
    case invalidData
    case unknown
    
    var title: String {
        switch self {
        case .add:
            "New Album"
        case .delete(let album):
            "Delete \"\(album.name)\""
        case .invalidURL, .invalidResponse, .invalidData, .unknown:
            "Server Error"
        }
    }
    
    var message: String {
        switch self {
        case .add:
            "Enter a name for this album."
        case .delete(let album):
            "Are you sure you want to delete the album \"\(album.name)\"? The Photos will not be deleted."
        case .invalidURL:
            "The data received from the server was invalid. Please contact support."
        case .invalidResponse:
            "Invalid response from the server. Please try again later or contact support."
        case .invalidData:
            "There was an issue connecting to the server. If this persists, please contact support."
        case .unknown:
            "Unable to complete your request at this time. Please check your internet connection."
        }
    }
}
