//
//  AlbumContainer.swift
//  Photos-ish
//
//  Created by Juhyun Yun on 8/13/24.
//

import Foundation
import SwiftData

actor AlbumContainer {
    
    @MainActor
    static func create(shouldCreateDefaults: inout Bool) -> ModelContainer {
        let schema = Schema([Album.self])
        let config = ModelConfiguration()
        let container = try! ModelContainer(for: schema, configurations: config)
        if shouldCreateDefaults {
            let recents = Album(name: "Recents", date: Date(), isEditable: false)
            let favorites = Album(name: "Favorites", date: Date(), isEditable: false)
            container.mainContext.insert(recents)
            container.mainContext.insert(favorites)
            shouldCreateDefaults = false
        }
        return container
    }
}
